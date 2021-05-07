clear
cd "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets"

use "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Directory\Directory_Cleanv2.dta"

merge m:1 unitid using "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Characteristics\Characteristics_Cleanv2", keep(1 3)
drop _merge

save "Directory+Characteristics", replace

//Now let us starting adding our variable datasets. Let's start with earnings.
use "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Directory+Characteristics.dta"
merge m:1 unitid using "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Earnings\Earnings_Cleanv2.dta", keep(1 3)
drop _merge

save "Directory+Characteristics+Earnings", replace

//Next up we have Outcomes. 

use "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Directory+Characteristics+Earnings.dta"
merge m:1 unitid using "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Outcomes\Outcomes_CleanV2.dta", keep(1 3)
drop _merge

save "Directory+Characteristics+Earnings+Outcomes", replace

//Next is Repayment. 
use "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Directory+Characteristics+Earnings+Outcomes.dta"
merge m:1 unitid using "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Repayment\Repayment_Cleanv2.dta", keep(1 3)
drop _merge

save "Directory+Characteristics+Earnings+Outcomes+Repayment", replace

//Next is Grad Rates. 
use "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Directory+Characteristics+Earnings+Outcomes+Repayment.dta"
merge m:1 unitid using "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Grad Rates\GradRates_Cleanv2.dta", keep(1 3)
drop _merge

save "Directory+Characteristics+Earnings+Outcomes+Repayment+GradRates", replace

//Next is Finance. 
use "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Directory+Characteristics+Earnings+Outcomes+Repayment+GradRates.dta"
merge 1:1 unitid using "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Finance\Finance_CleanV2.dta", keep(1 3)
drop _merge

save "Directory+Characteristics+Earnings+Outcomes+Repayment+GradRates+Finance", replace

//Next is Financial Responsibility.
use "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Directory+Characteristics+Earnings+Outcomes+Repayment+GradRates+Finance.dta"
merge m:1 unitid using "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Financial Responsibility\FinancialResponsibility_Cleanv2.dta", keep(1 3)
drop _merge

save "Directory+Characteristics+Earnings+Outcomes+Repayment+GradRates+FinancialResponsibility", replace

//Let's add student's Living Arrangments. 
use "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Directory+Characteristics+Earnings+Outcomes+Repayment+GradRates+FinancialResponsibility.dta"
merge m:1 unitid using "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Living Arrangement\LivingArrangement_CleanV2.dta", keep(1 3)
drop _merge

save "Directory+Characteristics+Earnings+Outcomes+Repayment+GradRates+FinancialResponsibility+LivingArrangment", replace

