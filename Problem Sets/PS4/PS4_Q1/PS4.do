


clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS4"
infile lnhr lnwg kids ageh agesq disab id year using "MOM.dat", clear
save "PS4.dta", replace

gen random_num = runiform()     
keep if random_num <= 0.5       
drop random_num                 
save "PS4_subsample.dta", replace 
clear
//don't run it again



clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS4"
use "PS4_subsample.dta"



//Pooled OLS
reg lnhr lnwg
outreg2 using "myreg.doc", replace ctitle(Pooled OLS) dec(4) keep(lnhr lnwg)

//two-way Fixed effects
preserve
xtset id year
xtreg lnhr lnwg i.year, fe
outreg2 using "myreg.doc", append ctitle(Two-way FE) addtext(Individual FE, YES, Year FE, YES) dec(4) keep(lnhr lnwg)
restore

//within estimator
preserve
xtset id year
xtreg lnhr lnwg, fe
outreg2 using "myreg.doc", append ctitle(within (FE)) addtext(Individual FE, YES) dec(4) keep(lnhr lnwg)
restore

//between estimator
preserve
xtset id year
xtreg lnhr lnwg, be
outreg2 using "myreg.doc", append ctitle(between) dec(4) keep(lnhr lnwg)
restore

//first difference
preserve
gen d_lnhr = lnhr - lnhr[_n-1] if id == id[_n-1]
gen d_lnwg = lnwg - lnwg[_n-1] if id == id[_n-1]
drop if d_lnhr == . 
drop if d_lnwg == . 
reg d_lnhr d_lnwg
outreg2 using "myreg2.doc", replace ctitle(first diff) dec(4) keep(d_lnhr d_lnwg)
restore

//random effects GLS
preserve
xtset id year
xtreg lnhr lnwg, re
outreg2 using "myreg2.doc", append ctitle(re GLS) dec(4) keep(lnhr lnwg)
restore

//random effects MLE
preserve
xtset id year
xtreg lnhr lnwg, mle
outreg2 using "myreg2.doc", append ctitle(re MLE (i)) dec(4) keep(lnhr lnwg)
restore

//random effects MLE (iii)
preserve
xtset id year
bootstrap, reps(200): xtreg lnhr lnwg, mle
outreg2 using "myreg2.doc", append ctitle(re MLE (iii)) dec(4) keep(lnhr lnwg)
restore

/////////////robust check/////////////

//pooled OLS
reg lnhr lnwg 
outreg2 using "myreg3.doc", replace ctitle(Pooled OLS) addtext(Robust, NO) dec(4) keep(lnhr lnwg)
//pooled OLS Robust
reg lnhr lnwg , robust 
outreg2 using "myreg3.doc", append ctitle(Pooled OLS) addtext(Robust, YES) dec(4) keep(lnhr lnwg) 

//within estimator
preserve
xtset id year
xtreg lnhr lnwg, fe 
outreg2 using "myreg3.doc", append ctitle(within (FE)) addtext(Individual FE, YES, Robust, NO) dec(4) keep(lnhr lnwg)
//within estimator Robust
xtreg lnhr lnwg, fe vce(robust)
outreg2 using "myreg3.doc", append ctitle(within (FE)) addtext(Individual FE, YES, Robust, YES) dec(4) keep(lnhr lnwg)
restore

//random effects GLS
preserve
xtset id year
xtreg lnhr lnwg, re
outreg2 using "myreg3.doc", append ctitle(re GLS) addtext(Robust, NO) dec(4) keep(lnhr lnwg)
//random effects GLS Robust
xtreg lnhr lnwg, re vce(robust)
outreg2 using "myreg3.doc", append ctitle(re GLS) addtext(Robust, YES) dec(4) keep(lnhr lnwg)
restore

/*
//random effects MLE
preserve
xtset id year
xtreg lnhr lnwg, mle
outreg2 using "myreg3.doc", append ctitle(re MLE) addtext(Robust, NO) dec(4) keep(lnhr lnwg)
//random effects MLE Robust
xtreg lnhr lnwg, mle vce(robust)
outreg2 using "myreg3.doc", append ctitle(re MLE) addtext(Robust, YES) dec(4) keep(lnhr lnwg)
restore
*/

////////////////////////f////////////////////////

/*
clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS4"
use "PS4_subsample.dta"

xtset id year
xtreg lnhr lnwg, fe
matrix b_fe = e(b)          // Save FE coefficients
matrix V_fe = e(V)          // Save FE variance-covariance matrix

xtreg lnhr lnwg, re
matrix b_re = e(b)          // Save RE coefficients
matrix V_re = e(V)          // Save RE variance-covariance matrix

matrix b_diff = b_fe - b_re                     // Compute difference in coefficients
matrix V_diff = V_fe - V_re                     // Compute difference in variance-covariance matrices
matrix H = b_diff' * syminv(V_diff) * b_diff    // Compute Hausman test statistic
scalar chi2 = H[1,1]                            // Extract test statistic value
scalar p_value = chi2tail(rows(b_diff), chi2)   // Compute p-value
*/


clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS4"
use "PS4_subsample.dta"
xtset id year
xtreg lnhr lnwg , fe
estimates store fixed_effects
xtreg lnhr lnwg , re
estimates store random_effects
********** Hausman Test **********
hausman fixed_effects random_effects





/*
xtreg lnhr lnwg, fe 
matrix b_fe = e(b)         
matrix V_fe = e(V) 
      
xtreg lnhr lnwg, re 
matrix b_re = e(b)         
matrix V_re = e(V)         

matrix b_diff = b_fe - b_re
matrix V_diff = V_fe - V_re

matrix V_diff_inv = invsym(V_diff)   

matrix hausman_stat_matrix = b_diff * V_diff_inv * b_diff
scalar hausman_stat = hausman_stat_matrix[1,1]   // Extract the scalar value

display "Hausman test statistic: " hausman_stat

scalar df = colsof(b_diff)
scalar p_value = chi2tail(df, hausman_stat)
*/







