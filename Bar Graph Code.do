clear 

cd "C:\Users\valer\OneDrive\EDUC 711\Thesis Graphics"

use "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\Final_UNCFProject_Data"

// Let's create an indicator for CPI Institutions
foreach code in 144005 190646 198543 177940 151810 163453 232937 221838 101587 {
replace hbcu = "CPI" if unitid == `code'
}

// Let's create an indicator for UNCF Member Institions. 
foreach code in 217624 197993 132602 133526 140146 198862 101675 218399 140720 107600 199582 199643 228884 234164{
replace hbcu = "UNCF Member" if unitid == `code'
}

// Let's create an indicator for institutions that are a part of CPI and a member institution. 
foreach code in 217721 217873 138947 158802 220181 133979 225575 225885 198756 220598 220604 140553 101912 176318 141060 102270 102298 176406 102377 218919 206491 229887 160904{
replace hbcu = "Both" if unitid == `code'
} 

graph bar repay_rate_pell repay_rate_nopell, over(hbcu) ytitle("Repayment Rate of Student Loans") b1title("Type of University") graphregion(color(white)) bar(1, color ("70 150 241")) blabel(bar, format(%3.2f) position(center) color(white) size(small))title("Student Loan Repayment Across Colleges & Universities", color(black)) subtitle("By College & University Type in 2017") 
