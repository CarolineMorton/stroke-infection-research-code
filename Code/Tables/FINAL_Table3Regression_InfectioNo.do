*********************************************************
//** early dementia **//*********************************
*********************************************************

use post_stroke_dementia_dataset_final, clear /*Option 1*/
drop if linked_hes==0 /*Option 2*/
use post_stroke_dementia_dataset_final_hosp, clear /*Option 3*/
use post_stroke_dementia_dataset_final_hosp_prim, clear /*Option 4*/

replace end = min(str_date+365.25, end)
stset end, failure(early_dem==1) enter(start) origin(str_date) id(patid) scale(365.25)

replace eth5 = . if eth5==4
replace alcstatus = 0 if alcstatus == 2

stsplit exp=eventdate1, at(0)
*stsplit infect_band, after(first_infect_date) at (0)
replace exp=exp + 1

stsplit exp2=eventdate2, at(0)
replace exp2=exp2 + 1
replace exp = exp + exp2

strate exp, per(1000)

*********************************************************
**************Unadjusted analysis************************
*********************************************************

stcox i.exp, base

*********************************************************
**************Age and sex adjusted analysis**************
*********************************************************

stcox i.exp i.age_cat i.gender, base

*********************************************************
**************Full Model analysis************************
*********************************************************

stcox i.exp i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base
estimates store a
quietly stcox i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base
estimates store b
lrtest a b

*********************************************************
**************Effect modification************************
*********************************************************

stcox i.exp##i.recurrent_str i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base
estimates store a
stcox i.exp i.recurrent_str i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base
estimates store b
lrtest a b

*********************************************************
//** LATE dementia **//*********************************
*********************************************************

use post_stroke_dementia_dataset_final, clear
drop if linked_hes==0
use post_stroke_dementia_dataset_final_hosp, clear
use post_stroke_dementia_dataset_final_hosp_prim, clear

replace eth5 = . if eth5==4
replace alcstatus = 0 if alcstatus == 2

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

stsplit exp4=eventdate4, at(0)
replace exp4=exp4 + 1
replace exp = exp + exp4

stsplit exp5=eventdate5, at(0)
replace exp5=exp5 + 1
replace exp = exp + exp5

strate exp, per(1000)

*********************************************************
**************Unadjusted analysis************************
*********************************************************

stcox i.exp, base

*********************************************************
**************Age and sex adjusted analysis**************
*********************************************************

stcox i.exp i.age_cat i.gender, base

*********************************************************
**************Full Model analysis************************
*********************************************************

stcox exp i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base
estimates store a
quietly stcox i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base
estimates store b
lrtest a b

*********************************************************
**************Effect modification************************
*********************************************************

quietly stcox i.exp##i.recurrent_str i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base
estimates store a
quietly stcox i.exp i.recurrent_str i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base
estimates store b
lrtest a b
