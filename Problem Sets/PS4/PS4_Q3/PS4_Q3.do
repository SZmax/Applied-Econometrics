
clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS4_Q3"
use wagepan.dta

//////////////////a//////////////////

//Pooled OLS
reg lwage educ black hisp exper expersq married union 
outreg2 using "myreg.doc", replace ctitle(Pooled OLS) addtext(Robust, NO) dec(4)
//Robust
reg lwage educ black hisp exper expersq married union, robust
outreg2 using "myreg.doc", append ctitle(Pooled OLS) addtext(Robust, YES) dec(4)
//Cluster id
reg lwage educ black hisp exper expersq married union, cluster(nr)
outreg2 using "myreg.doc", append ctitle(Pooled OLS) addtext(Cluster, YES) dec(4)



//////////////////b//////////////////

reg lwage educ black hisp exper expersq married union, cluster(nr)
outreg2 using "myreg2.doc", replace ctitle(Pooled OLS) addtext(Cluster, YES) dec(4)

xtset nr year
//Random Effects
xtreg lwage educ black hisp exper expersq married union, re 
outreg2 using "myreg2.doc", append ctitle(Random Effects) addtext(Robust, NO) dec(4)
//Robust
xtreg lwage educ black hisp exper expersq married union, re vce(robust)
outreg2 using "myreg2.doc", append ctitle(Random Effects) addtext(Robust, YES) dec(4)


//////////////////c//////////////////

//Random Effects
xtreg lwage educ black hisp exper expersq married union, re 
outreg2 using "myreg3.doc", replace ctitle(Random Effects) addtext(Robust, NO) dec(4)
//Robust
xtreg lwage educ black hisp exper expersq married union, re vce(robust)
outreg2 using "myreg3.doc", append ctitle(Random Effects) addtext(Robust, YES) dec(4)
//two-way Fixed Effects
xtreg lwage i.year educ black hisp exper expersq married union, fe 
outreg2 using "myreg3.doc", append ctitle(two-way FE) addtext(Robust, NO) dec(4)
//Robust
xtreg lwage i.year educ black hisp exper expersq married union, fe vce(robust)
outreg2 using "myreg3.doc", append ctitle(two-way FE) addtext(Robust, YES) dec(4)


//////////////////d//////////////////

gen d81_educ = d81*educ
gen d82_educ = d82*educ
gen d83_educ = d83*educ
gen d84_educ = d84*educ
gen d85_educ = d85*educ
gen d86_educ = d86*educ
gen d87_educ = d87*educ

xtreg lwage educ black hisp exper expersq married union d81_educ d82_educ d83_educ d84_educ d85_educ d86_educ d87_educ, fe
outreg2 using "myreg4.doc", replace ctitle(FE) dec(4)


//////////////////e//////////////////


gen lead_union = f1.union
xtreg lwage educ black hisp exper expersq married union lead_union, fe 
outreg2 using "myreg5.doc", replace ctitle(FE) dec(4)



