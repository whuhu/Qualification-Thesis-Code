cd "C:\Users\huhu\Desktop\资格论文\data"

use "reg_data.dta",clear

//SEM
use "reg_data.dta",clear

//SEM eduy3
sem (eduy3 <- pctile edu_f edu_m isei_f isei_m) (isei <- eduy3 pctile edu_f edu_m isei_f isei_m),vce(bootstrap,reps(5000)) 
estat teffects
medsem, indep(pctile) med(eduy3) dep(isei) mcreps(5000) rit rid 


keep if eduy3==3
sem (eduy3 <- pctile edu_f edu_m isei_f isei_m) (isei <- eduy3 pctile edu_f edu_m isei_f isei_m),vce(bootstrap,reps(500)) 
estat teffects
medsem, indep(pctile) med(eduy3) dep(isei) mcreps(5000) rit rid 

keep if eduy3==2
sem (eduy <- pctile edu_f edu_m isei_f isei_m) (isei <- eduy pctile edu_f edu_m isei_f isei_m),vce(bootstrap,reps(200)) 
medsem, indep(pctile) med(eduy) dep(isei) mcreps(5000) rit rid 

keep if eduy3==1
sem (eduy <- pctile edu_f edu_m isei_f isei_m) (isei <- eduy pctile edu_f edu_m isei_f isei_m),vce(bootstrap,reps(200)) 
medsem, indep(pctile) med(eduy) dep(isei) mcreps(5000) rit rid 


sem (eduy3 <- pctile edu_f edu_m isei_f isei_m) (isei <- eduy3 pctile edu_f edu_m isei_f isei_m), group(eduy3) vce(bootstrap,reps(5000)) 




*for different income, income invest path
use "reg_data.dta",clear
keep if pctile<=50
sem (eduy3 <- pctile edu_f edu_m isei_f isei_m) (isei <- eduy3 pctile edu_f edu_m isei_f isei_m),vce(bootstrap,reps(5000)) 
estat teffects
medsem, indep(pctile) med(eduy3) dep(isei) mcreps(5000) rit rid 

use "reg_data.dta",clear
keep if pctile>50
gsem (eduy <- pctile edu_f edu_m isei_f isei_m gender i.prov urban ethnic) (isei <- eduy pctile edu_f edu_m isei_f isei_m gender i.prov urban ethnic),vce(bootstrap,reps(1000)) 
estat teffects
medsem, indep(pctile) med(eduy3) dep(isei) mcreps(5000) rit rid 


use "panel_with_pctile.dta",clear
keep if pctile>50
sem (eduy3 <- pctile edu_f edu_m isei_f isei_m) (isei <- eduy3 pctile edu_f edu_m isei_f isei_m),vce(bootstrap,reps(1000)) 
estat teffects
medsem, indep(pctile) med(eduy3) dep(isei) mcreps(5000) rit rid 



*******************************************************
*casual mediation analysis using medeff

use "reg_data.dta",clear
gen good=0
replace good=1 if isei>40

medeff(regress eduy pctile edu_f edu_m isei_f isei_m) (probit good pctile eduy edu_f edu_m isei_f isei_m),treat(pctile) mediate(eduy) sims(1000)

medsens (regress eduy pctile edu_f edu_m isei_f isei_m) (probit good pctile eduy edu_f edu_m isei_f isei_m),eps(.01) treat(pctile) mediate(eduy) sims(1000)

twoway rarea _med_updelta0 _med_lodelta0 _med_rho, bcolor(gs14) || line _med_delta0 _med_rho , lcolor(black) ytitle("Average mediation effect") xtitle("Sensitivity parameter: p") legend(off) title("ACME(p)")

*----
keep if pctile<=50
medeff(regress eduy pctile edu_f edu_m isei_f isei_m) (probit good pctile eduy edu_f edu_m isei_f isei_m),treat(pctile) mediate(eduy) sims(1000)

medsens (regress eduy pctile edu_f edu_m isei_f isei_m) (probit good pctile eduy edu_f edu_m isei_f isei_m),eps(.01) treat(pctile) mediate(eduy) sims(1000)

twoway rarea _med_updelta0 _med_lodelta0 _med_rho, bcolor(gs14) || line _med_delta0 _med_rho , lcolor(black) ytitle("Average mediation effect") xtitle("Sensitivity parameter: p") legend(off) title("ACME(p)")

*----medsen probit for good
keep if pctile>50
medeff(regress eduy pctile edu_f edu_m isei_f isei_m) (probit good pctile eduy edu_f edu_m isei_f isei_m),treat(pctile) mediate(eduy) sims(1000)

medsens (regress eduy pctile edu_f edu_m isei_f isei_m) (probit good pctile eduy edu_f edu_m isei_f isei_m),eps(.01) treat(pctile) mediate(eduy) sims(1000)

twoway rarea _med_updelta0 _med_lodelta0 _med_rho, bcolor(gs14) || line _med_delta0 _med_rho , lcolor(black) ytitle("Average mediation effect") xtitle("Sensitivity parameter: p") legend(off) title("ACME(p)")


medeff (regress eduy pctile edu_f edu_m isei_f isei_m) (regress isei pctile edu edu_f edu_m isei_f isei_m), mediate(edu) treat(pctile) sims(1000)




outreg2 using sem.doc,replace tstat ctitle(y) bdec(3) tdec(2) addtext(SEM without threshold)
