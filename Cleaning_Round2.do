clear
cd "C:\Users\valer\OneDrive\EDUC 711\Data"
 
//Code to clean the tab "Directory" of the Master Data file. 
import excel "C:\Users\valer\OneDrive\EDUC 711\[Master] UNCF Data with Variable Directory.xlsx", sheet("UNCF HBCU Directory") firstrow
destring, replace

drop opeid inst_alias address state_abbr fips zip phone_number county_fips cbsa cbsa_type csa necta longitude latitude ein duns chief_admin_name currently_active_ipeds date_closed newid year_deleted inst_control sector primarily_postsecondary url_school url_fin_aid url_application url_netprice url_veterans url_athletes url_disability_services cc_basic_2010 cc_instruc_undergrad_2010 cc_instruc_grad_2010 cc_undergrad_2010 cc_enroll_2010 cc_size_setting_2010 cc_basic_2000 cc_basic_2015 cc_instruc_undergrad_2015 cc_instruc_grad_2015 cc_undergrad_2015 cc_enroll_2015 cc_size_setting_2015 cc_basic_2018 cc_instruc_undergrad_2018 cc_instruc_grad_2018 cc_undergrad_2018 cc_enroll_2018 cc_size_setting_2018 comparison_group comparison_group_custom inst_system_flag inst_system_name reporting_method CE CF

foreach code in 217624 217721 197993 132602 144005 190035 217873 138947 158802 133526 198543 220181 133979 225575 140146 225885 198756 220598 220604 177940 198862 151810 101675 140553 163453 218399 232937 101912 140720 107600 176318 199582 199643 141060 102270 102298 221838 228884 176406 102377 101587 234164 218919 206491 229887 160904 {
replace hbcu = "Yes(UNCF)" if unitid == `code'
}

drop if unitid ==.
drop if year ==.

save "MasterData_Directory.xlsx", replace

//Now lets clean the tab "Finance" of the Master Data file. 
clear
import excel "C:\Users\valer\OneDrive\EDUC 711\[Master] UNCF Data with Variable Directory.xlsx", sheet("Finance") firstrow
destring, replace

drop fips liabilities parent_child_flag parent_child_system_flag parent_unitid parent_child_allocation reporting_form form_type gasb_alternative_accounting athletic_expense_treatment cpi hepi heca est_fte rep_fte calc_fte
drop if unitid ==.

save "MasterData_Finace.xlsx", replace

//Now lets clean the tab "Financial Responsibility" of the Master Data file. 
clear
import excel "C:\Users\valer\OneDrive\EDUC 711\[Master] UNCF Data with Variable Directory.xlsx", sheet("Financial Responsibility") firstrow
destring, replace

drop H I J K L M N O P Q R S T U V W X
drop if unitid ==.

save "MasterData_FinacialResponsibility.xlsx", replace

//Now lets clean the tab "Outcomes" of the Master Data file.
clear
import excel "C:\Users\valer\OneDrive\EDUC 711\[Master] UNCF Data with Variable Directory.xlsx", sheet("Outcomes") firstrow
destring, replace 

drop if unitid ==.

replace award_cert_8yr = 0 if missing(award_cert_8yr)
replace award_assoc_8yr = 0 if missing(award_assoc_8yr)
replace award_bach_8yr = 0 if missing(award_bach_8yr)

save "MasterData_Outcomes.xlsx", replace

//Now lets clean the tab "Grad Rates" of the Master Data file.
clear 
import excel "C:\Users\valer\OneDrive\EDUC 711\[Master] UNCF Data with Variable Directory.xlsx", sheet("Grad Rates") firstrow
destring, replace 

drop S T U
drop still_enrolled_long_program completers_100pct

drop if race =="American Indian or Alaska Native"
drop if race =="Hispanic"
drop if race =="Asian"
drop if race =="Native Hawaiian or other Pacific Islander"
drop if race =="Two or more races"
drop if race =="Unknown"

save "MasterData_GradRates.xlsx", replace

//Now lets clean the tab "Repayment" of the Master Data file.
clear 
import excel "C:\Users\valer\OneDrive\EDUC 711\[Master] UNCF Data with Variable Directory.xlsx", sheet("Repayment") firstrow
destring, replace 

drop if unitid ==.
drop opeid opeid6 fips
// All cells with "Suppressed" were replaced with a zero in excel!

save "MasterData_Repayment.xlsx"

//Now lets clean the tab "Living Arrangement" of the Master Data file.
clear 
import excel "C:\Users\valer\OneDrive\EDUC 711\[Master] UNCF Data with Variable Directory.xlsx", sheet("Living Arrangement") firstrow
destring, replace

drop L M N O P Q R S T U V W X Y
drop fips 
drop ftpt level_of_study degree_seeking

save "MasterData_LivingArrangement.xlsx", replace

//Finally, lets clean the tab "Room, Board, & Other Expenses" of the Master Data file.
clear
import excel "C:\Users\valer\OneDrive\EDUC 711\[Master] UNCF Data with Variable Directory.xlsx", sheet("Room, Board, & Other Expenses") firstrow
destring, replace 

drop I J K L M N O P Q R S T U V W X Y Z

save "MasterData_RoomBoardOtherExpenses.xlsx", replace
