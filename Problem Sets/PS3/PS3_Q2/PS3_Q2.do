/////////////////a/////////////////

clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q2"
import delimited "lalonde_nsw.csv", clear
keep if treat == 1
save "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q2\a\nsw.dta", replace
clear

cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q2"
import delimited "lalonde_psid.csv", clear
append using "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q2\a\nsw.dta"
gsort - treat

logit treat age education hispanic black married nodegree re74 re75
predict pscore

save "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q2\a\Soal2", replace

summarize pscore if treat == 1
di "Average propensity score for treated: " r(mean)

summarize pscore if treat == 0
di "Average propensity score for control: " r(mean)

twoway (kdensity pscore if treat == 1, lcolor(blue) lwidth(medium) ///
        lpattern(solid) legend(label(1 "Treated"))) ///
       (kdensity pscore if treat == 0, lcolor(red) lwidth(medium) ///
        lpattern(dash) legend(label(2 "Control"))), ///
       xlabel(0(0.1)1) ylabel(, angle(horizontal)) ///
       title("Propensity Score Density for Treated and Control Groups") ///
       xtitle("Propensity Score") ytitle("Density")

	   
	   
twoway (kdensity pscore if treat == 1, lcolor(blue) lwidth(medium) ///
        lpattern(solid) legend(label(1 "Treated")) bw(0.02)) ///
       (kdensity pscore if treat == 0, lcolor(red) lwidth(medium) ///
        lpattern(dash) legend(label(2 "Control")) bw(0.02)), ///
       xlabel(0(0.1)1) ylabel(, angle(horizontal)) ///
       title("Propensity Score Density for Treated and Control Groups") ///
       xtitle("Propensity Score") ytitle("Density")
	   

/////////////////b/////////////////


clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q2\a"
use Soal2.dta

teffects ipw (re78) (treat age education black hispanic married nodegree), pomeans
teffects ipw (re78) (treat age education black hispanic married nodegree)

summarize treat
local p_treat = r(mean)
gen sipw = (treat * `p_treat'/ps) + ((1 - treat) * (1 - `p_treat')/(1 - ps))
teffects ipw (re78) (treat age education hispanic black married nodegree) [pweight=sipw], pomeans
teffects ipw (re78) (treat age education hispanic black married nodegree) [pweight=sipw]


/*
gen ipw = (treat / pscore) + ((1 - treat) / (1 - pscore))
summarize re78 [aw=ipw] if treat == 1
di "IPW estimate for treated mean: " r(mean)
summarize re78 [aw=ipw] if treat == 0
di "IPW estimate for control mean: " r(mean)
di "ATE (IPW): IPW_Treatment - IPW_Control" 

gen prob_treated = sum(treat) / _N
gen sipw = (treat * prob_treated / pscore) + ((1 - treat) * (1 - prob_treated) / (1 - pscore))
summarize re78 [aw=sipw] if treat == 1
di "SIPW estimate for treated mean: " r(mean)
summarize re78 [aw=sipw] if treat == 0
di "SIPW estimate for control mean: " r(mean)
di "ATE (IPW): SIPW_Treatment - SIPW_Control"
*/

/////////////////c/////////////////

clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q2\a"
use Soal2.dta
regress re78 treat age education hispanic black married nodegree re74 re75
outreg2 using soal2_c.doc, replace

/////////////////d/////////////////

clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q2\a"
use Soal2.dta
keep if pscore >= 0.1 & pscore <= 0.9

teffects ipw (re78) (treat age education black hispanic married nodegree), pomeans
teffects ipw (re78) (treat age education black hispanic married nodegree)

summarize treat
local p_treat = r(mean)
gen sipw = (treat * `p_treat'/ps) + ((1 - treat) * (1 - `p_treat')/(1 - ps))
teffects ipw (re78) (treat age education hispanic black married nodegree) [pweight=sipw], pomeans
teffects ipw (re78) (treat age education hispanic black married nodegree) [pweight=sipw]

/*
gen ipw = (treat / pscore) + ((1 - treat) / (1 - pscore))
summarize re78 [aw=ipw] if treat == 1
di "IPW estimate for treated mean: " r(mean)
summarize re78 [aw=ipw] if treat == 0
di "IPW estimate for control mean: " r(mean)

gen prob_treated = sum(treat) / _N
gen sipw = (treat * prob_treated / pscore) + ((1 - treat) * (1 - prob_treated) / (1 - pscore))
summarize re78 [aw=sipw] if treat == 1
di "SIPW estimate for treated mean: " r(mean)
summarize re78 [aw=sipw] if treat == 0
di "SIPW estimate for control mean: " r(mean)
di "ATE (IPW): SIPW_Treatment - SIPW_Control"
*/

/////////////////e/////////////////
//black
clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q2\a"
use Soal2.dta
keep if pscore >= 0.1 & pscore <= 0.9
keep if black == 1

teffects ipw (re78) (treat age education hispanic married nodegree), pomeans
teffects ipw (re78) (treat age education hispanic married nodegree)

summarize treat
local p_treat = r(mean)
gen sipw = (treat * `p_treat'/ps) + ((1 - treat) * (1 - `p_treat')/(1 - ps))
teffects ipw (re78) (treat age education hispanic married nodegree) [pweight=sipw], pomeans
teffects ipw (re78) (treat age education hispanic married nodegree) [pweight=sipw]

//non-black
clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q2\a"
use Soal2.dta

keep if pscore >= 0.1 & pscore <= 0.9
keep if black == 0

teffects ipw (re78) (treat age education hispanic married nodegree), pomeans
teffects ipw (re78) (treat age education hispanic married nodegree)

summarize treat
local p_treat = r(mean)
gen sipw = (treat * `p_treat'/ps) + ((1 - treat) * (1 - `p_treat')/(1 - ps))
teffects ipw (re78) (treat age education hispanic married nodegree) [pweight=sipw], pomeans
teffects ipw (re78) (treat age education hispanic married nodegree) [pweight=sipw]



/////////////////f/////////////////

clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q2\a"
use Soal2.dta
gen diff_re78_re75 = re78 - re75
regress diff_re78_re75 treat
outreg2 using soal2_f.doc, replace ctitle (i) dec(4)
regress re78 treat re75
outreg2 using soal2_f.doc, append ctitle(ii) dec(4)
