********************************************************
************** TABLE 2: REGRESSION 1st Infection *******
********************************************************

*********************************************************
//** early dementia **//*********************************
*********************************************************

use post_stroke_dementia_dataset_final, clear /*Option 1*/
drop if linked_hes==0 /*Option 2*/
use post_stroke_dementia_dataset_final_hosp, clear /*Option 3*/
use post_stroke_dementia_dataset_final_hosp_prim, clear /*Option 4*/

drop if when_infect == 1
recode country_1 4=2

replace end = min(str_date+365.25, end)
stset end, failure(early_dem==1) enter(start) origin(str_date) id(patid) scale(365.25)

stsplit exp=eventdate1, at(0)
*stsplit infect_band, after(first_infect_date) at (0)
replace exp=exp + 1

replace eth5 = . if eth5==4
replace alcstatus = 0 if alcstatus == 2

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

quietly stcox i.exp i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base 
drop if bmi_cat==.


*********************************************************
**************Effect modification************************
*********************************************************

stcox i.exp##i.recurrent_str i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base /*HR 1.65 */
estimates store a
stcox i.exp i.recurrent_str i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base /*HR 1.65 */
estimates store b
lrtest a b /*p = 0.6864*/

*********************************************************
***************** LATE dementia *************************
*********************************************************

use post_stroke_dementia_dataset_final, clear
drop if linked_hes==0
use post_stroke_dementia_dataset_final_hosp, clear
use post_stroke_dementia_dataset_final_hosp_prim, clear

drop if when_infect == 1
recode country_1 4=2

replace start = max(str_date+365.25, start)
stset end, failure(late_dem==1) enter(start) origin(str_date) id(patid) scale(365.25)
stsplit exp=eventdate1, at(0)
*stsplit infect_band, after(first_infect_date) at (0)
replace exp=exp + 1

replace eth5 = . if eth5==4
replace alcstatus = 0 if alcstatus == 2

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

stcox i.exp i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base /*HR 1.65 */
estimates store a
quietly stcox i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base /*HR 1.65 */
estimates store b
lrtest a b

drop if bmi_cat==.

*********************************************************
**************Effect modification************************
*********************************************************

stcox i.exp##i.recurrent_str i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression , base /*HR 1.65 */
estimates store a
stcox i.exp i.recurrent_str i.age_cat i.gender i.cons_cat_post i.eth5 i.imd_5 i.country_1 i.smokstatus i.alcstatus ib1.bmi_cat i.diab i.afib i.mi i.statin i.bp_meds i.immunosup_meds i.aps_90 i.depression if bmi_cat!=., base /*HR 1.65 */
estimates store b
lrtest a b