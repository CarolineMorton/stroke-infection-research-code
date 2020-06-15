* Load Data file *

use "J:\EHR-Working\Charlotte_Harriet\Caroline\Dataset\data\cleandata\post_stroke_dementia_dataset_final.dta", clear

/*
Objective 1)
We will model the incidence of post-stroke //
dementia in stroke survivors by ethnicity status. We will fit Cox //
proportionate hazard models to obtain hazard ratios for dementia in patients //
of different ethnicities, accounting for the covariates described above.
*/

gen age_cat = age_stroke
replace age_cat = 1 if age_stroke <60
replace age_cat = 2 if age_stroke <75 & age_stroke >59
replace age_cat = 3 if age_stroke <85 & age_stroke >74
replace age_cat = 4 if age_stroke >84
lab def age 1 "40 to 59 years" 2 "60 to 74 years" 3 "75 to 84 years" 4 "Over 85 years"
lab val age_cat age
tab age_cat

replace smokstatus = 3 if smokstatus ==1
replace smokstatus = 1 if smokstatus == 2
replace smokstatus = 2 if smokstatus == 3
lab def smok 0 "non-smoker" 1 "ex-smoker" 2 "current smoker"
lab val smokstatus smok

replace early_dem = 0 if early_dem==.
replace late_dem = 0 if late_dem==.
replace late_dem = . if early_dem==1

gen total_infect = count_1d_3m + count_3m_1y + count_1y_5y
replace total_infect = 2 if total_infect > 1 & total_infect < 6
replace total_infect = 3 if total_infect > 1 & total_infect >5
lab def inf1 0 "No infections" 1 "1 infection" 2 "2 to 5 infections" 3 "6 + infections"
lab val total_infect inf1

lab def inf2 0 "No infections" 1 "1 infection" 2 "2+ infections"
replace count_1d_3m = 2 if count_1d_3m > 1
lab val count_1d_3m inf2
replace count_3m_1y = 2 if count_3m_1y > 1
lab val count_3m_1y inf2
replace count_1y_5y = 2 if count_1y_5y > 1
lab val count_1y_5y inf2

stset end, failure(dementia_study_period ==1) enter(start) id(patid) origin(str_date) scale(365.25)
tab eth5, nolabel
replace eth5 = 3 if eth5 > 2
