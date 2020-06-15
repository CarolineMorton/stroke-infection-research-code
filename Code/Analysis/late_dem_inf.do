//** late dementia **//
use "J:\EHR-Working\Charlotte_Harriet\Caroline\Dataset\data\cleandata\post_stroke_dementia_dataset_final.dta", clear

replace start = max(str_date+365.25, start)
stset end, failure(late_dem==1) enter(start) origin(str_date) id(patid) scale(365.25)
*stsplit time_band, at(0(1)max) after(time=str_date)
stsplit exp=first_infect_date, at(0)
*stsplit infect_band, after(first_infect_date) at (0)
replace exp=exp + 1

replace eth5 = . if eth5==4
replace alcstatus = 0 if alcstatus == 2


*Unadjusted analysis
stcox i.exp, base

*Age and sex adjusted analysis
stcox i.exp i.age_cat i.gender, base

*Step 1 buidling a model
stcox i.exp i.age_cat i.gender i.eth5, base
stcox i.exp i.age_cat i.gender i.cons_cat_post, base
stcox i.exp i.age_cat i.gender i.imd_5, base
stcox i.exp i.age_cat i.gender i.country_1, base
stcox i.exp i.age_cat i.gender i.smokstatus, base
stcox i.exp i.age_cat i.gender i.alcstatus, base
stcox i.exp i.age_cat i.gender i.bmi_cat, base
stcox i.exp i.age_cat i.gender i.diab, base
stcox i.exp i.age_cat i.gender i.afib, base
stcox i.exp i.age_cat i.gender i.mi, base
stcox i.exp i.age_cat i.gender i.statin, base
stcox i.exp i.age_cat i.gender i.bp_meds, base
stcox i.exp i.age_cat i.gender i.immunosup_meds, base
stcox i.exp i.age_cat i.gender i.aps_90, base
stcox i.exp i.age_cat i.gender i.depression, base


/*Model with everything in it*/
stcox i.exp i.age_cat i.gender ib2.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base
stcox i.age_cat i.gender ib2.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base


/*Effect modification */
stcox i.exp##i.recurrent_str i.age_cat i.gender, base
estimates store a
stcox i.exp i.recurrent_str i.age_cat i.gender, base
estimates store b
lrtest a b


*Unadjusted analysis
stcox i.exp, base

*Age and sex adjusted analysis
stcox i.exp i.age_cat i.gender, base

*Step 1 buidling a model
stcox i.exp i.age_cat i.gender i.eth5, base
stcox i.exp i.age_cat i.gender i.cons_cat_post, base
stcox i.exp i.age_cat i.gender i.imd_5, base
stcox i.exp i.age_cat i.gender i.country_1, base
stcox i.exp i.age_cat i.gender i.smokstatus, base
stcox i.exp i.age_cat i.gender i.alcstatus, base
stcox i.exp i.age_cat i.gender i.bmi_cat, base
stcox i.exp i.age_cat i.gender i.diab, base
stcox i.exp i.age_cat i.gender i.afib, base
stcox i.exp i.age_cat i.gender i.mi, base
stcox i.exp i.age_cat i.gender i.statin, base
stcox i.exp i.age_cat i.gender i.bp_meds, base
stcox i.exp i.age_cat i.gender i.immunosup_meds, base
stcox i.exp i.age_cat i.gender i.aps_90, base
stcox i.exp i.age_cat i.gender i.depression, base
stcox i.exp i.age_cat i.gender i.recurrent_str , base


/*Model with everything in it*/
stcox i.exp i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus i.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base

/*Effect modification */
stcox i.exp##i.recurrent_str i.age_cat i.gender, base
estimates store a
stcox i.exp i.recurrent_str i.age_cat i.gender, base
estimates store b
lrtest a b /*p = 0.1315*/





