/////////////////a/////////////////




/*
logit treat age education black hispanic married nodegree re74 re75
predict pscore, pr

xtile pscore_group = pscore, n(5)
sort pscore_group
foreach var in age education black hispanic married nodegree re74 re75 {
    by pscore_group: ttest `var', by(treat)
}


logit treat age education black married nodegree re74 re75 // removed 'hispanic'
predict pscore_new, pr
xtile pscore_group_new = pscore_new, n(5)
sort pscore_group_new
foreach var in age education black married nodegree re74 re75 {
    by pscore_group_new: ttest `var', by(treat)
}
*/

clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q3"
import delimited "lalonde_nsw.csv", clear

psmatch2 treat (age education black hispanic married nodegree re74 re75), common
pstest age education black hispanic married nodegree re74 re75, graph
graph export graph1.svg , replace
psgraph, bin(20) treated(treat) 
graph export graph2.svg , replace

xtile block = _pscore, nq(4)

preserve
keep if block == 1
psgraph, bin(20) treated(treat) 
pstest age education black hispanic married nodegree re74 re75, graph
graph export graph4.svg , replace
restore

preserve
keep if block == 2
psgraph, bin(20) treated(treat)
pstest age education black hispanic married nodegree re74 re75, graph
graph export graph6.svg , replace
restore

preserve
keep if block == 3
psgraph, bin(20) treated(treat) 
pstest age education black hispanic married nodegree re74 re75, graph
graph export graph8.svg , replace
restore

preserve
keep if block == 4
psgraph, bin(20) treated(treat)
pstest age education black hispanic married nodegree re74 re75, graph
graph export graph10.svg , replace
restore



psmatch2 treat (age education black hispanic nodegree), common
pstest age education black hispanic nodegree, graph
graph export graph_1.png , replace
psgraph, bin(20) treated(treat) 
graph export graph_2.png , replace

preserve
keep if block == 1
psgraph, bin(20) treated(treat) 
pstest age education black hispanic married nodegree, graph
graph export graph_4.png , replace
restore

preserve
keep if block == 2
psgraph, bin(20) treated(treat)
pstest age education black hispanic married nodegree, graph
graph export graph_6.png , replace
restore

preserve
keep if block == 3
psgraph, bin(20) treated(treat) 
pstest age education black hispanic married nodegree, graph
graph export graph_8.png , replace
restore

preserve
keep if block == 4
psgraph, bin(20) treated(treat)
pstest age education black hispanic married nodegree, graph
graph export graph_10.png , replace
restore







/////////////////b/////////////////

clear 
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q3"
import delimited "lalonde_nsw.csv", clear
logit treat age education black hispanic married nodegree re74 re75
predict pscore, pr
xtile pscore_group = pscore, n(10)
tab pscore_group treat



/////////////////c/////////////////


clear 
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q3"
import delimited "lalonde_nsw.csv", clear

regress treat age education black hispanic married nodegree re74 re75
predict pscore_ols

sum pscore_ols if treat == 0
sum pscore_ols if treat == 1

tabstat pscore_ols, by(treat) stats(mean sd min max)



/////////////////d/////////////////

clear 
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS3_Q3"
import delimited "lalonde_nsw.csv", clear

logit treat age education black hispanic married nodegree re74 re75
predict pscore, pr

forvalues num = 0(0.1)0.3 {
    local num_clean = subinstr("`num'", ".", "_", .)
    gen pscore_`num_clean' = (pscore > `num') & (pscore <= `num' + 0.1)
}


forvalues num = 0(0.1)0.3 {
    local num_clean = subinstr("`num'", ".", "_", .)
    gen pscore_treat_`num_clean' = pscore_`num_clean' * treat
}


reg re78 pscore_0 pscore__1 pscore__2 treat pscore_treat_0 pscore_treat__1 pscore_treat__2

outreg2 using q3_d.doc, replace

/////////////////e/////////////////

reg re78 pscore_0 pscore__1 pscore__2 treat pscore_treat_0 pscore_treat__1 pscore_treat__2 age education black hispanic married nodegree re74 re75

outreg2 using q3_e.doc, replace



