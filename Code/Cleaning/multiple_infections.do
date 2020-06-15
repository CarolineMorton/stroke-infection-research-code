*********************************************************
**************Determine Multiple Infections**************
*********************************************************

*Flag those within 28 days of last and drop

use lrti_all, clear
gen start_lrti=lrti_eventdate
gen end_lrti=lrti_eventdate+27 /*ADD 1 month to end of Rx*/
format end_lrti start_lrti %td
drop if lrti_event==.
bysort patid (lrti_eventdate): gen littlen=_n
*flag infections in same episode -  give them the same littlen value
by patid: replace littlen=littlen[littlen-1] if start_lrti<end_lrti[_n-1]  & _n!=1
*collapse infections with overlapping dates: take earliest start and latest end date
collapse (min) start_lrti (max) end_lrti (min) lrti_eventdate, by(patid littlen lrti)  
drop littlen start end
rename lrti_eventdate eventdate
rename lrti infectionType
save lrti_multi, replace

use uti_all, clear
gen start_uti=uti_eventdate
gen end_uti=uti_eventdate+27 /*ADD 1 months to end of Rx*/
format end_uti start_uti %td
drop if uti_event==.
bysort patid (uti_eventdate): gen littlen=_n
*flag infections in same episode -  give them the same littlen value
by patid: replace littlen=littlen[littlen-1] if start_uti<end_uti[_n-1]  & _n!=1
*collapse infections with overlapping dates: take earliest start and latest end date
collapse (min) start_uti (max) end_uti (min) uti_eventdate, by(patid littlen uti)  
drop littlen start end
*Find the infections in study period
rename uti_eventdate eventdate
rename uti infectionType
replace infectionType=2 if infectionType==1
save uti_multi, replace

use ssti_all, clear
gen start_ssti=ssti_eventdate
gen end_ssti=ssti_eventdate+27 /*ADD 3 months to end of Rx*/
format end_ssti start_ssti %td
drop if ssti_event==.
bysort patid (ssti_eventdate): gen littlen=_n
*flag infections in same episode -  give them the same littlen value
by patid: replace littlen=littlen[littlen-1] if start_ssti<end_ssti[_n-1]  & _n!=1
*collapse infections with overlapping dates: take earliest start and latest end date
collapse (min) start_ssti (max) end_ssti (min) ssti_eventdate, by(patid littlen ssti)  
drop littlen start end
rename ssti_eventdate eventdate
rename ssti infectionType
replace infectionType=3 if infectionType==1
save ssti_multi, replace

use lrti_multi, clear
append using uti_multi
append using ssti_multi
lab def type1 1 "LRTI" 2 "UTI" 3 "SSTI"
lab val infectionType type1

sort patid (eventdate)
duplicates drop patid eventdate, force /*remove duplicates (same patient, same day)*/
sort patid eventdate
save infection_multi, replace

use infection_multi, clear
*Find the infections in study period
merge m:1 patid using post_stroke_dementia_dataset_v5, keep(match) nogen /*196406*/

drop if eventdate > end
drop if eventdate < str_date
keep patid eventdate infectionType
*do for each infection type, combine and make littlen
bysort patid (eventdate): gen littlen=_n
keep if littlen<=3
*reshape
reshape wide eventdate infectionType, i(patid) j(littlen)
save infection_collapsed, replace

use post_stroke_dementia_dataset_v5, clear
merge 1:1 patid using infection_collapsed
drop _m
replace eventdate1=d(01jan2050) if eventdate1==.
replace eventdate2=d(01jan2050) if eventdate2==.
replace eventdate3=d(01jan2050) if eventdate3==.

replace smokstatus = 3 if smokstatus ==1
replace smokstatus = 1 if smokstatus == 2
replace smokstatus = 2 if smokstatus == 3
lab def smok 0 "non-smoker" 1 "ex-smoker" 2 "current smoker"
lab val smokstatus smok

replace eth5 = 3 if eth5 == 4
replace eth5 = 4 if eth5 == 5
lab def eth 0 "White" 1 "South Asian" 2 "Black" 3 "Mixed/Other" 4 "Unknown"
lab val eth5 eth

gen country_1 = .
replace country_1 = 1 if strmatch("England", country)
replace country_1 = 2 if strmatch("Wales", country)
replace country_1 = 3 if strmatch("Scotland", country)
replace country_1 = 4 if strmatch("N Ireland", country)
lab def countrylab 1 "England" 2 "Wales" 3 "Scotland" 4 "N Ireland"
lab val country_1 countrylab
tab country_1

gen cons_cat_post = cons_post_str
replace cons_cat_post = 1 if cons_cat_post <10
replace cons_cat_post = 2 if cons_cat_post >= 10 & cons_cat_post <20
replace cons_cat_post = 3 if cons_cat_post >= 20 & cons_cat_post <30
replace cons_cat_post = 4 if cons_cat_post >= 30 & cons_cat_post <50
replace cons_cat_post = 5 if cons_cat_post >= 50
lab def post 1 "< 10 per year" 2 "10 - 20 per year" 3 "20 - 30 per year" 4"30 - 50 per year" 5 "> 50 per year"
lab val cons_cat_post post


gen age_cat = age_stroke
replace age_cat = 1 if age_stroke <60
replace age_cat = 2 if age_stroke <75 & age_stroke >59
replace age_cat = 3 if age_stroke <85 & age_stroke >74
replace age_cat = 4 if age_stroke >84
lab def age 1 "40 to 59 years" 2 "60 to 74 years" 3 "75 to 84 years" 4 "Over 85 years"
lab val age_cat age
tab age_cat


save post_stroke_dementia_dataset_multi, replace
