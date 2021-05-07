clear
cd "C:\Users\valer\OneDrive\EDUC 711\Data"

import excel "C:\Users\valer\OneDrive\EDUC 711\Data\NearestNeighborMatch_2017.xlsx", firstrow sheet("Directory") clear 
destring, replace
tab unitid

// We're going to get rid of schools in regions we don't need at all. To do this, we're going to make a new var and drop based on it
gen HBCUregion = "No"

count // 7,153
foreach region in "Great Lakes: IL, IN, MI, OH, and WI" "Mid East: DE, DC, MD, NJ, NY, and PA" "Plains: IA, KS, MN, MO, NE, ND, and SD" "Southeast: AL, AR, FL, GA, KY, LA, MS, NC, SC, TN, VA, and WV" "Southwest: AZ, NM, OK, and TX" {
replace HBCUregion = "Yes" if region ==`"`region'"'
}
tab HBCUregion // No = 1,862 Yes = 5,291
drop if HBCUregion =="No"
drop HBCUregion
count // 5,291
* Now we're going to drop based on institution size using the same method
* For the variable inst_size we want to get rid of "Not applicable", "10000-19,999", "20000 and above", and "Missing/NotReported"
foreach size in "Not applicable" "Missing/not reported" "10,000–19,999" "20,000 and above" {
drop if inst_size == `"`size'"'
}
count // 4,639

foreach code in 217624 217721 197993 132602 144005 190035 217873 138947 158802 133526 198543 220181 133979 225575 140146 225885 198756 220598 220604 177940 198862 151810 101675 140553 163453 218399 232937 101912 140720 107600 176318 199582 199643 141060 102270 102298 221838 228884 176406 102377 101587 234164 218919 206491 229887 160904 {
replace hbcu = "Yes(UNCF)" if unitid == `code'
}

count // 4,639

save "NearestNeighborMatch_2017_Master.dta", replace

* Now we just want to add pell grant data to this master data file

clear
use "NearestNeighborMatch_2017_Master.dta"
merge 1:1 unitid using "NearestNeighborMatch_2017_Clean", keepusing(sch_pell_grant) keep(1 3)

replace sch_pell_grant = 0 if missing(sch_pell_grant)

drop _merge

save "NearestNeighborMatch_2017_Master_PellGrant", replace


/* Unitid 190035 isn't present within the master data sheet... therefore it isn't present to do 
Propensity Matching with... Ask Haisheng about this!
*/

* Now we're going to drop based on grad rates using the same methods previously used.
* We will be dropping from three variables: ftpt, fed_aid_type, and class_level so we can look a the totals for each college and university. 

clear
import excel "C:\Users\valer\OneDrive\EDUC 711\Data\NearestNeighborMatch_2017.xlsx", firstrow sheet("Outcomes") clear 

// Dataset is not uniquely identified at unitid level, so we drop everything that is not a "total" value
drop if ftpt =="Full-time"
drop if ftpt =="Part-time"

drop if fed_aid_type =="Total"
drop if fed_aid_type =="Not recipients of Pell"

drop if class_level =="First-time"
drop if class_level =="Other (transfer-ins or non-first-time-entering)"

drop if award_bach_6yr ==.
drop if award_bach_6yr ==0

* Now we're going to create a variable to show the true grad rate 6 years after the cohort began. 
gen grad_rate_6yr = (award_bach_6yr / cohort_rev)
label variable grad_rate_6yr "Graduation Rate"
save "NearestNeighborMatch_2017.dta", replace

*** STOP STOP STOP ***

//Add grad rates to the master file
clear
use "NearestNeighborMatch_2017_Master_PellGrant"
merge 1:1 unitid using "NearestNeighborMatch_2017.dta", keepusing(grad_rate_6yr) keep(1 3)
drop _merge

// Make inst_size a numeric variable for nnmatch
encode inst_size, generate(inst_size_n)
label variable inst_size_n "Encoded Institution Size Variable"

// Make region a numeric variable (useful for nnmatch which can't use string variables)
encode region, generate(region_n)
label variable region_n "Encoded Region Variable"

// Make hbcu_n a dummy variable for the purposes of nnmatch (treatment variable, so only 2 levels allowed)
// Comparing UNCF schools to non HBCU's 
gen hbcu_n =.
replace hbcu_n = 0 if hbcu =="No"
replace hbcu_n = 1 if hbcu =="Yes(UNCF)"
label variable hbcu_n "hbcu dummy 0 = non hbcu 1 = UNCF hbcu"

// Comparing UNCF schools to HBCU's (Not necessarily relevant but if so here's the code for it)
gen hbcu_n_yes =.
replace hbcu_n_yes = 0 if hbcu =="Yes"
replace hbcu_n_yes = 1 if hbcu =="Yes(UNCF)"
label variable hbcu_n_yes "hbcu dummy 0 = hbcu 1 = UNCF hbcu"

// I realized this dataset has a lot of useful variables, so I dropped the useless ones
drop year inst_alias address state_abbr zip phone_number city county_name county_fips cbsa cbsa_type csa necta longitude latitude congress_district_id ein duns chief_admin_name chief_admin_title currently_active_ipeds postsec* date_closed year_deleted inst_control sector primarily* hospital medical_degree offering* url* cc*

// We can't use data from any school that doesn't publish their grad rates, so drop unnecessary data
drop if grad_rate_6yr ==.
// Check to see if we have any 0's which could be missing values, just misinterpreted
tab grad_rate_6yr

//Modify the dataset to included the UNCF descriptors. 
drop if title_iv_indicator =="Stopped participating during the survey year"
drop if title_iv_indicator =="Not currently participating in Title IV, has an OPE ID number"
drop if title_iv_indicator =="Deferment only, limited participation"
drop if title_iv_indicator =="Branch campus of a main campus that participates in Title IV"
drop if title_iv_indicator =="Not currently participating in Title IV, does not have OPE ID number"
drop if title_iv_indicator =="New participants (became eligible during the spring collection period)"

drop if inst_control=="Private for-profit"

save "IPEDsData_Combined", replace

// Save the file.
save "NearestNeighborMatch_2017_GradRates",replace









