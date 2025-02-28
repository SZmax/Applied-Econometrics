

clear
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS4_Q2"
use norway.dta
xtset district year

//Pooled OLS
reg lcrime d78 clrprc1 clrprc2
outreg2 using "myreg.doc", replace ctitle(Pooled OLS) addtext(Robust, NO) dec(4)
predict residuals, resid
gen lag_resid = l6.residuals
regress residuals lag_resid d78 clrprc1 clrprc2
outreg2 using "myreg2.doc", replace ctitle(Test For Serial Correlation)



//Fixed Effects
xtreg lcrime d78 clrprc1 clrprc2, fe
outreg2 using "myreg.doc", append ctitle(Fixed Effects) addtext(Individual FE, YES, Robust, NO) dec(4)


//Fixed Effects Robust
xtreg lcrime d78 clrprc1 clrprc2, fe vce(robust)
outreg2 using "myreg.doc", append ctitle(Fixed Effects) addtext(Individual FE, YES, Robust, YES) dec(4)

test clrprc1 = clrprc2

gen clrprc_combined = clrprc1 + clrprc2
xtreg lcrime d78 clrprc_combined, fe vce(robust)
outreg2 using "myreg3.doc", replace ctitle(Fixed Effects) addtext(Individual FE, YES, Robust, YES) dec(4)
