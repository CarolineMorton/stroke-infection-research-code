
use hospitalisation_all, clear
duplicates drop patid hospitalisation_eventdate , force /*remove duplicates (same patient, same day)*/
sort patid hospitalisation_eventdate
drop if hosp_infect_diag_no ==2
*Generate start and end of episode for each infection
gen start_hospitalisation=hospitalisation_eventdate
gen end_hosp=hospitalisation_eventdate+27 /*ADD 3 months to end of Rx*/
format start_hospitalisation end_hosp %td
drop if hospitalisation_eventdate==.
bysort patid (hospitalisation_eventdate): gen littlen=_n
*flag infections in same episode -  give them the same littlen value
by patid: replace littlen=littlen[littlen-1] if start_hospitalisation<end_hosp[_n-1]  & _n!=1
*collapse infections with overlapping dates: take earliest start and latest end date
collapse (min) start_hospitalisation (max) end_hosp (min) hospitalisation_eventdate, by(patid littlen HES_infection)  
drop littlen start end
*Find the infections in study period
merge m:1 patid using post_stroke_dementia_dataset_v5, keep(match) nogen
drop if hospitalisation_eventdate > end
drop if hospitalisation_eventdate < str_date
keep patid HES_infection hospitalisation_eventdate
*do for each infection type, combine and make littlen
bysort patid (hospitalisation_eventdate): gen littlen=_n
keep if littlen<=3
*reshape
reshape wide hospitalisation_eventdate, i(patid) j(littlen)
save hosp_collapsed_1ryonly, replace


use lrti_collapsed, clear
merge 1:1 patid using uti_collapsed
drop _m
merge 1:1 patid using ssti_collapsed
drop _m
merge 1:1 patid using hosp_collapsed_1ryonly
drop _m
save all_infections_hosp2, replace

********************************************************************************
************MERGE WITH STROKE DATASET ******************************************
********************************************************************************

use post_stroke_dementia_dataset_v5, clear
merge 1:1 patid using all_infections_hosp2
drop _m

gen first_infect_date = min(ssti_eventdate1,  uti_eventdate1, lrti_eventdate1, hospitalisation_eventdate1)
replace first_infe=d(01jan2050) if first==.
format first_infect_date %td

gen type_inf = 0
replace type_inf = 1 if first_infect_date==lrti_eventdate1
replace type_inf = 2 if first_infect_date==uti_eventdate1
replace type_inf = 3 if first_infect_date==ssti_eventdate1
replace type_inf = 4 if first_infect_date==hospitalisation_eventdate1

replace type_inf = . if type==0
lab def typelab 1" LRTI" 2 "UTI" 3 "SSTI" 4 "Hospital infection"
lab val type_inf typelab
lab var type_inf "Type of First Infection"

gen when_infect=0 
replace when_infect=1 if  first_infect_date<=str_date+91.32
replace when_infect=2 if first_infect_date>str_date+91.32 & first_infect_date<=str_date+365.25
replace when_infect=3 if first_infect_date>str_date+365.25 & first_infect_date<=str_date+1826.25
lab var when_infect "When first infection"
lab def when 0 "No infection" 1 "Infection < 3m" 2 "Infection 3m - 1y" 3 "Infection 1 - 5 years"
lab val when_infect when

lab var first_infect_date "Date of First Infection in Study Period"

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

drop if linked_hes ==0

save post_stroke_dementia_dataset_final_hosp2, replace
