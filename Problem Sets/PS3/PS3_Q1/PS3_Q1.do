//////////////////a//////////////////



clear
// the paper wants to calculate the treatment effect on real earning 78
//ssc install outreg2

cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3"
import delimited "lalonde_nsw.csv", clear
gen agesq=age*age
logit treat age agesq education black hispanic married nodegree re74 re75 

predict pscore, pr

//gen pscore_bin = ceil(pscore * 10) / 10
gen pscore_interval = floor(pscore / 0.1)

regress re78 treat i.pscore_interval
outreg2 using soal3_1.doc, replace


//////////////////e//////////////////


clear 

//ssc install psmatch2
//ssc install cem
//ssc install kmatch
//ssc install asdoc

cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3"
import delimited "lalonde_nsw.csv", clear

gen race = cond(black == 1, "black", cond(hispanic == 1, "hispanic", "others"))
gen match_key = race + "_" + string(married) + "_" + string(nodegree)
egen group_id = group(match_key)

drop black hispanic married nodegree race match_key
sort treat group_id

preserve
keep if treat == 1
rename * *_treat
rename group_id_treat group_id
gen `c(obs_t)' case_num = _n
save temp_treated, replace

restore
keep if treat == 0
rename * *_control
rename group_id_control group_id
gen `c(obs_t)' case_num_control = _n
save temp_control, replace

clear

use "C:\Users\SZmax\Desktop\Advancedmetrics\PS3\temp_treated.dta"
joinby group_id using "C:\Users\SZmax\Desktop\Advancedmetrics\PS3\temp_control.dta"
//for counting the number of exact matches of the control group on the treatment
egen unique_count = tag(case_num_control)
count if unique_count
drop unique_count
//doing the exact matching and randomly asigning a match from the control group for each treatment because we may have many matches from the control group for each treatment
gen double shuffle1 = runiform()
by case_num (shuffle1),sort: keep if _n == 1
drop shuffle1 group_id
order case_num, before(treat_treat)
order case_num_control, before(treat_control)
save temp_matched, replace

clear
use "C:\Users\SZmax\Desktop\Advancedmetrics\PS3\temp_matched.dta"
list(case_num treat_treat age_treat education_treat)
export excel case_num treat_treat age_treat education_treat using "C:\Users\SZmax\Desktop\Advancedmetrics\PS3\soal3_e_treat.xls", firstrow(variables) replace
export excel case_num case_num_control treat_control age_control education_control using "C:\Users\SZmax\Desktop\Advancedmetrics\PS3\soal3_e_control.xls", firstrow(variables) replace

//////////////////f//////////////////


clear
//ssc install outreg2
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3"
use temp_matched.dta

preserve
keep case_num treat_treat age_treat education_treat re74_treat re75_treat re78_treat
rename treat_treat treat
rename age_treat age
rename education_treat education
rename re74_treat re74
rename re75_treat re75
rename re78_treat re78 
save temp_treated_f, replace

restore
keep case_num_control treat_control age_control education_control re74_control re75_control re78_control
rename case_num_control case_num
rename treat_control treat
rename age_control age
rename education_control education
rename re74_control re74
rename re75_control re75
rename re78_control re78 
save temp_control_f, replace

clear

cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3"
use temp_treated_f.dta
append using temp_control_f
drop case_num
regress re78 treat age education re74 re75
outreg2 using soal3_f.doc, replace


//////////////////g//////////////////


clear

cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3"
import delimited "lalonde_nsw.csv", clear

gen race = cond(black == 1, "black", cond(hispanic == 1, "hispanic", "others"))
gen match_key = race + "_" + string(married) + "_" + string(nodegree) + string(re74)
egen group_id = group(match_key)

drop black hispanic married nodegree race match_key
sort treat group_id

preserve
keep if treat == 1
rename * *_treat
rename group_id_treat group_id
gen `c(obs_t)' case_num = _n
save temp_treated_g, replace

restore
keep if treat == 0
rename * *_control
rename group_id_control group_id
gen `c(obs_t)' case_num_control = _n
save temp_control_g, replace

clear

use "C:\Users\SZmax\Desktop\Advancedmetrics\PS3\temp_treated_g.dta"
joinby group_id using "C:\Users\SZmax\Desktop\Advancedmetrics\PS3\temp_control_g.dta"
//for counting the number of exact matches of the control group on the treatment
egen unique_count = tag(case_num_control)
count if unique_count
drop unique_count
//doing the exact matching and randomly asigning a match from the control group for each treatment because we may have many matches from the control group for each treatment
gen double shuffle1 = runiform()
by case_num (shuffle1),sort: keep if _n == 1
drop shuffle1 group_id
order case_num, before(treat_treat)
order case_num_control, before(treat_control)
save temp_matched_g, replace

clear
use "C:\Users\SZmax\Desktop\Advancedmetrics\PS3\temp_matched_g.dta"
list(case_num treat_treat age_treat education_treat)
export excel case_num treat_treat age_treat education_treat using "C:\Users\SZmax\Desktop\Advancedmetrics\PS3\soal3_g_treat.xls", firstrow(variables) replace
export excel case_num case_num_control treat_control age_control education_control using "C:\Users\SZmax\Desktop\Advancedmetrics\PS3\soal3_g_control.xls", firstrow(variables) replace

//////////////////h//////////////////

clear
//ssc install asdoc

cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3"
use temp_matched_g
keep re74_treat  re74_control
asdoc summarize re74_treat re74_control, save(C:\Users\SZmax\Desktop\Advancedmetrics\PS3\h\soal3_h1.doc), replace

clear

cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3"
import delimited "lalonde_nsw.csv", clear
keep re74
asdoc summarize re74, save(C:\Users\SZmax\Desktop\Advancedmetrics\PS3\h\soal3_h2.doc), replace


//////////////////j//////////////////
//ssc install estout

clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3"
import delimited "lalonde_nsw.csv", clear
teffects nnmatch (re78 black hispanic married nodegree) (treat), dmvariables atet
tebalance summarize

teffects psmatch (re78) (treat black hispanic married nodegree), caliper(0.1) atet
tebalance summarize

//////////////////k//////////////////

logit treat black hispanic married nodegree
predict pscore
psmatch2 treat, outcome(re78) mahalanobis(married nodegree black hispanic)
pstest married nodegree black hispanic, graph