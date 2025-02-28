clear

ssc install outreg2
cd "C:\Users\SZmax\Desktop\Advancedmetrics\PS1\2"
use attend.dta
noisily reg stndfnl atndrte frosh soph
outreg2 using soal2.doc, replace
noisily reg stndfnl atndrte frosh soph priGPA ACT
outreg2 using soal2.doc, append
noisily reg stndfnl atndrte frosh soph priGPA c.priGPA#c.priGPA ACT c.ACT#c.ACT
outreg2 using soal2.doc, append
noisily reg stndfnl atndrte c.atndrte#c.atndrte frosh soph priGPA c.priGPA#c.priGPA ACT c.ACT#c.ACT
outreg2 using soal2.doc, append