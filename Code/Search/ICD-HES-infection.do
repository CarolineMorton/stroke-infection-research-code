use "icd.dta", clear

/*Make lower case*/

foreach var of varlist description {
gen Z=lower(`var')
drop `var'
rename Z `var'
}

// STEP 1: DEFINE SEARCH TERMS
loc interm " "*infect*" "*sepsi*" "*septi*" "*pneumonia*" "*osteomyelitis*" "*staphylococcal*" "*pneumococcal*" "*streptococcal*" "*rheumatic fever*" "*viral*" "*bacterial*" "*influe*" "*abscess*" "*empyema*" "*cellulitis*" "*pyothorax*" "*meningitis*" "*pyogenic*""*acute cystitis*" "*acute prostatitis*"  "
loc interm "`interm'"


/// STEP 2: WORD SEARCH OF GPRD MEDICAL CODE DICTIONARY
*** update the marker where read term matches search terms
gen infect=.
foreach word in `interm'{
           replace infect = 1 if strmatch(description, "`word'")
          }

	
// STEP 3: CODE SEARCH OF GPRD MEDICAL CODE DICTIONARY
*** search for specific terms not found by word search using read codes
         
loc incode ""B20*" "*A*" "*B0*" "*B1*" "*N51*" "*B23.0*" "*B25*" "*B26*" "*B27*" "*B3*" "*B4*" "*B5*" "*B6*" "*B7*" "*B8*" "*B9*" "*J0*" "*J1*" "*J2*" "*L0*" "

foreach word in `incode'{
   replace infect = 1 if strmatch(code,"`word'") 
   }
   
// STEP 4: DROP ALL TERMS NOT CAPTURED BY SEARCH TERMS
keep if infect==1

// STEP 5: EXCLUDE TERMS TO MAKE SEARCH MORE SPECIFIC
loc exterm " "" "*history*" "*benign*" "*postinfect*" "*non-infect*" "*noxious*" "*lymphadenitis*" "*aseptic*" "*nonpyogenic*""*chronic mul*" "*chronic men*" "*chronic oste*" "*chronic para*" "*chronic viral*" "*chronic pul*""*chronic int*" "*screen*" "*drugs*" "*poison*" "*without*" "*postviral fatigue*" "*resistance to antiviral*" "*vacc*" "*congenital*" "*noninfect*" "*anti-inf*" "*immu*" "*at risk*" "*vacc*" "*carrier*" "*contact*" "*asympt*" "
loc exterm "`exterm'"

foreach word in `exterm' {
        drop if strmatch(description,"`word'") 
         }

rename code icd
		 
keep icd description infect
sort icd

save initial_search, replace

