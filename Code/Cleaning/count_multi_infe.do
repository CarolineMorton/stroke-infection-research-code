*********************************************************
**************Create infection counts********************
*********************************************************

/* Combine LRTI, UTI and SSTI counts */

use lrti_count, clear
append using uti_count
append using ssti_count
append using hosp_collapsed_1ryonly_all
egen x = group(patid)
sort x
gen type =.
replace type = 1 if lrti==1
replace type = 2 if uti==1
replace type = 3 if ssti==1
replace type = 4 if HES_infection==1
tab type

bysort patid (x): gen littlen=_n
collapse x (max)littlen, by(patid)
sum littlen, detail
