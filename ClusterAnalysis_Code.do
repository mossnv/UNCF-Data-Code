clear
cd "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets"

use "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets\IPEDsData_Combined"

destring, replace

//Make sure the dataset utilizes the proper title IV indicators.
drop if title_iv_indicator =="Stopped participating during the survey year"
drop if title_iv_indicator =="Not currently participating in Title IV, has an OPE ID number"
drop if title_iv_indicator =="Deferment only, limited participation"
drop if title_iv_indicator =="Branch campus of a main campus that participates in Title IV"
drop if title_iv_indicator =="Not currently participating in Title IV, does not have OPE ID number"
drop if title_iv_indicator =="New participants (became eligible during the spring collection period)"

//Drop all for-profit institutions.
drop if inst_control=="Private for-profit"

//Drop all community colleges, technical schools, and other institutions not offering four-year degrees. 
drop if sector =="Public, two-year"
drop if sector =="Public, less-than two-year"
drop if sector =="Private not-for-profit, two-year"
drop if sector =="Private not-for-profit, less-than-two-year"

save "Final_UNCFProject_Data", replace

clear
cd "C:\Users\valer\OneDrive\EDUC 711\Data\Whole Datasets"

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

// Now let us determine what clusters to use. 
local list2 "earnings_mean repay_rate_firstgen completion_rate_6yr exp_student_serv_total" 	 			 // This line is the macro for what we want to cluster.
forvalues k = 1/20 { 							
	cluster kmeans `list2', k(`k') start(random(123)) name(cs`k')
	}
* WSS matrix
matrix WSS = J(20,5,.)
matrix colnames WSS = k WSS log(WSS) eta-squared PRE
* WSS for each clustering
forvalues k = 1(1)20 { 																//number needs to match line 2 
	scalar ws`k' = 0
	foreach v of varlist `list2' {
		quietly anova `v' cs`k'
		scalar ws`k' = ws`k' + e(rss)
	}
	matrix WSS[`k', 1] = `k'
	matrix WSS[`k', 2] = ws`k'
	matrix WSS[`k', 3] = log(ws`k')
	matrix WSS[`k', 4] = 1 - ws`k'/WSS[1,2]
	matrix WSS[`k', 5] = (WSS[`k'-1,2] - ws`k')/WSS[`k'-1,2]
	}
local squared = char(178)
_matplot WSS, columns(2 1) connect(l) xlabel(#10) name(plot1, replace) nodraw noname
_matplot WSS, columns(3 1) connect(l) xlabel(#10) name(plot2, replace) nodraw noname  
_matplot WSS, columns(4 1) connect(l) xlabel(#10) name(plot3, replace) nodraw noname ytitle({&eta}`squared')
_matplot WSS, columns(5 1) connect(l) xlabel(#10) name(plot4, replace) nodraw noname
graph combine plot1 plot2 plot3 plot4, name(plot1to4, replace)*/

cluster kmeans earnings_mean repay_rate_firstgen completion_rate_6yr exp_student_serv_total, k(4) name(cluster)

//anytime you see a number in the parenthesis after k, change it to how many the graph indicates.

foreach var in earnings_mean repay_rate_firstgen completion_rate_6yr exp_student_serv_total {
	bys cluster: egen mean_`var' = mean(`var')
	bys cluster: egen sd_`var' = sd(`var')
	drop `var'
	}
	
gen hbcu2 = inlist(hbcu, "UNCF Member", "CPI", "Both")

collapse(mean) hbcu2 mean_earnings_mean mean_repay_rate_firstgen mean_completion_rate_6yr mean_exp_student_serv_total, by(cluster)


