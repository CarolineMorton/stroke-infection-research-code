
******************************************************************************
*************************ANALYSIS ********************************************
******************************************************************************
***Early Dementia *****

use post_stroke_dementia_dataset_multi2, clear
replace end = min(str_date+365.25, end)
stset end, failure(early_dem==1) enter(start) origin(str_date) id(patid) scale(365.25)
replace eth5 = . if eth5==4
replace alcstatus = 0 if alcstatus == 2
drop if linked_hes == 0

stsplit exp=eventdate1, at(0)
*stsplit infect_band, after(first_infect_date) at (0)
replace exp=exp + 1

stsplit exp2=eventdate2, at(0)
replace exp2=exp2 + 1
replace exp = exp + exp2


*Unadjusted analysis
stcox i.exp, base

stcox i.exp i.age_cat i.gender, base
stcox i.exp i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base
estimates store a
quietly stcox i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base
estimates store b
lrtest a b

***Late Dementia *****

use post_stroke_dementia_dataset_multi2, clear

replace start = max(str_date+365.25, start)
stset end, failure(late_dem==1) enter(start) origin(str_date) id(patid) scale(365.25)

stsplit exp=eventdate1, at(0)
*stsplit infect_band, after(first_infect_date) at (0)
replace exp=exp + 1

stsplit exp2=eventdate2, at(0)
replace exp2=exp2 + 1
replace exp = exp + exp2

stsplit exp3=eventdate3, at(0)
replace exp3=exp3 + 1
replace exp = exp + exp3
drop exp2 exp3

replace eth5 = . if eth5==4
replace alcstatus = 0 if alcstatus == 2


*Unadjusted analysis
stcox i.exp, base

stcox i.exp i.age_cat i.gender, base
stcox i.exp i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base

**********************************************
use post_stroke_dementia_dataset_multi2, clear
replace end = min(str_date+365.25, end)
stset end, failure(early_dem==1) enter(start) origin(str_date) id(patid) scale(365.25)

stsplit exp=eventdate1, at(0)
*stsplit infect_band, after(first_infect_date) at (0)
replace exp=exp + 1

replace eth5 = . if eth5==4
replace alcstatus = 0 if alcstatus == 2
drop if linked_hes == 0
replace exp=2 if exp==1 & infectionType1 ==2
replace exp=3 if exp==1 & infectionType1 ==3
replace exp=4 if exp==1 & infectionType1 ==4


