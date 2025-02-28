clear

ssc install outreg2

cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS1\1"
use hprice.dta

noisily reg price area rooms
outreg2 using soal1.doc, replace

predict pprice
gen residuals = pprice - price

/* NOTE: If you want to export the output table in Excel, use the extension *.xls instead of using *.doc */
