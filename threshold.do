global path "C:\Users\huhu\Desktop\资格论文20220831\资格论文"
global D    "$path\data"      //数据文件
global Out  "$path\out"       //结果：图形和表格
cd "$D"                       //设定当前工作路径
set scheme s2color

use "$Out\reg_data_ushape.dta",clear

*y: income loginc isei good 
*x: pctile inc_pa loginc_pa
*control: eduy_f eduy_m isei_f isei_m urban ethnic gender age
sem (eduy<-eduy_f eduy_m loginc_pa gender urban mid east age ethnic)(loginc<-eduy logisei loginc_pa gender urban mid east age ethnic)(logisei<-eduy logisei_f logisei_m loginc_pa gender urban mid east age ethnic)

*isei~inc eduy
drop if prov<0
(logisei<-eduy logisei_f logisei_m loginc_pa gender urban mid east age ethnic)
threshold logisei , threshvar(loginc_pa) regionvars(loginc_pa eduy logisei_f logisei_m gender urban mid east age ethnic) nthresh(1) nodots

threshold logisei , threshvar(loginc_pa) regionvars(loginc_pa eduy logisei_f logisei_m gender urban mid east age ethnic) optthresh(2) nodots

threshold logisei eduy logisei_f logisei_m gender urban mid east age ethnic, threshvar(loginc_pa) regionvars(loginc_pa) nthresh(1) nodots


*eduy~inc
threshold eduy , threshvar(loginc_pa) regionvars(loginc_pa eduy_f eduy_m  gender urban mid east age ethnic) nthresh(1) nodots

threshold eduy , threshvar(loginc_pa) regionvars(loginc_pa eduy_f eduy_m  gender urban mid east age ethnic) optthresh(2) nodots

*nice result
threshold eduy eduy_f eduy_m  gender urban mid east age ethnic, threshvar(loginc_pa) regionvars(loginc_pa) nthresh(1) nodots




















	use "reg_data_cohort_4.dta",clear
	foreach var in isei loginc_perm_f eduy_f mid east urban ethnic gender age{
		drop if `var'==.
	}
threshold logisei , threshvar(loginc_perm_f) regionvars(loginc_perm_f eduy_f isei_f isei_m urban ethnic gender age) nthresh(2) nodots
threshold logisei eduy, threshvar(loginc_perm_f) regionvars(loginc_perm_f  isei_f isei_m urban ethnic gender age) nthresh(2) nodots
**# okay
threshold logisei , threshvar(loginc_perm_f) regionvars(loginc_perm_f eduy isei_f isei_m urban ethnic gender age) nthresh(2) nodots

threshold good , threshvar(loginc_perm_f) regionvars(loginc_perm_f eduy_f isei_f isei_m urban ethnic gender age) nthresh(2) nodots
**# okay
threshold good eduy_f isei_f isei_m urban ethnic gender age, threshvar(loginc_perm_f) regionvars(loginc_perm_f ) nthresh(2) nodots
threshold good eduy, threshvar(loginc_perm_f) regionvars(loginc_perm_f  isei_f isei_m urban ethnic gender age) nthresh(2) nodots
threshold good , threshvar(loginc_perm_f) regionvars(loginc_perm_f eduy isei_f isei_m urban ethnic gender age) nthresh(2) nodots

gen pctile2=pctile^2
probit good pctile pctile2 eduy eduy_f mid east urban ethnic gender age

reg logisei pctile





threshold eduy eduy_f eduy_m isei_f isei_m urban i.prov ethnic gender age, threshvar(loginc_pa) regionvars(loginc_pa) nodots
threshold logisei eduy eduy_f eduy_m isei_f isei_m urban i.prov ethnic gender age, threshvar(pctile) regionvars(pctile) nthresh(2) nodots

threshold logisei eduy eduy_f eduy_m isei_f isei_m urban i.prov ethnic gender age, threshvar(eduy) regionvars(pctile) nodots

threshold good eduy eduy_f eduy_m isei_f isei_m urban i.prov ethnic gender age, threshvar(eduy) regionvars(loginc_pa) nodots
threshold good eduy_f eduy_m isei_f isei_m urban i.prov ethnic gender age, threshvar(loginc_pa) regionvars(eduy loginc_pa) nodots

***20220601 eduy sample classification
keep if eduy<13
threshold logisei eduy_f eduy_m isei_f isei_m urban ethnic gender age, threshvar(pctile) regionvars(pctile) nthresh(1) nodots

keep if eduy>12
threshold good eduy eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age, threshvar(pctile) regionvars(pctile) nthresh(1) nodots

gen eduinc=eduy*income_pa
threshold good eduy pctile eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age, threshvar(pctile) regionvars(eduinc) nthresh(1) nodots
reg logisei eduy pctile eduy_f eduy_m isei_f isei_m urban gender
reg isei eduy pctile




*vc_reg
gen pctile1=pctile
vc_bw isei pctile eduy eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age, vcoeff(eduy)
vc_reg isei pctile eduy eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age, vcoeff(eduy) klist(1(1)19)

 
graph combine grph1 grph2


graph export fig1.png, replace






threshold eduy eduy_f eduy_m isei_f isei_m urban ethnic gender age, threshvar(pctile) regionvars(pctile)

***
threshold income eduy eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age, threshvar(pctile) regionvars(pctile) nodots

threshold loginc eduy eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age, threshvar(loginc_pa) regionvars(loginc_pa) nodots

threshold income eduy eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age, threshvar(income_pa) regionvars(income_pa) nodots

threshold isei eduy eduy_f eduy_m isei_f isei_m urban ethnic gender age, threshvar(eduy) regionvars(pctile) nodots


threshold good eduy_f eduy_m isei_f isei_m urban ethnic gender age, threshvar(pctile) regionvars(eduy pctile)

threshold eduy eduy_f eduy_m isei_f isei_m urban ethnic gender age, threshvar(pctile) regionvars(pctile)
threshold logisei eduy eduy_f eduy_m isei_f isei_m urban ethnic gender age, threshvar(eduy) regionvars(pctile)
threshold good eduy_f eduy_m isei_f isei_m urban ethnic gender age, threshvar(pctile) regionvars(eduy pctile)

reg isei eduy eduy_f pctile eduy_m isei_f isei_m 



threshold eduy edu_f edu_m iseii_f isei_m, threshvar(pctile) regionvars(pctile)
threshold lnisei eduy edu_f edu_m isei_f isei_m, threshvar(pctile) regionvars(pctile)
threshold lnisei edu_f edu_m sei_f isei_m, threshvar(pctile) regionvars(eduy pctile)

threshold eduy edu_f edu_m isei_f isei_m, threshvar(lninc_pa) regionvars(lninc_pa)
threshold good eduy edu_f edu_m isei_f isei_m, threshvar(lninc_pa) regionvars(lninc_pa)
threshold good edu_f edu_m isei_f isei_m, threshvar(lninc_pa) regionvars(lninc_pa)
threshold good edu_f edu_m isei_f isei_m, threshvar(lninc_pa) regionvars(eduy lninc_pa)

threshold eduy edu_f edu_m isei_f isei_m, threshvar(lninc_pa) regionvars(lninc_pa)

threshold lnisei eduy edu_f edu_m isei_f isei_m, threshvar(lninc_pa) regionvars(lninc_pa)
threshold lnisei edu_f edu_m isei_f isei_m, threshvar(lninc_pa) regionvars(lninc_pa)
threshold lnisei edu_f edu_m sei_f isei_m, threshvar(lninc_pa) regionvars(eduy lninc_pa)



*medsen mediate
keep if pctile>50
medsens (regress eduy pctile edu_f edu_m isei_f isei_m) (probit good pctile eduy edu_f edu_m isei_f isei_m),eps(.01) treat(pctile) mediate(eduy) sims(1000)














/***************************************************************************

 (1) threshololdreg.ado

 Stata command "thresholdreg" computes estimates and confidence intervals for threshold models. 

 In Stata, You run it by typing:

 "thresholdreg y x, q(z) h(ind)"

example: thresholdreg y x1 x2, q(z) h(1)


  The inputs are:
  y = dependent variable
  x = independent variables
  z = threshold variable
  ind = heteroskedasticity indicator
      Set ind=0 to impose homoskedasticity assumption
      Set ind=1 to use White-correction for heteroskedasticity (default if option omitted)

The program estimates a threshold regression, prints the results to the screen.
The program also plots a graph of the likelihood ratio process in the threshold, useful for threshold confidence interval construction.


*******************************************************************************/
//thresholdreg
cd "C:\Users\huhu\Desktop\资格论文\data"

use "reg_data.dta",clear
thresholdreg isei eduy, q(pctile) h(1)

thresholdreg isei eduy edu_f edu_m isei_f isei_m, q(pctile) h(1)
thresholdreg isei eduy edu_f edu_m isei_f isei_m, q(income_pa) h(1)
thresholdreg eduy edu_f edu_m isei_f isei_m, q(pctile) h(1)

thresholdreg isei , q(pctile) h(1)

/*******************************************************************************

 (2) thresholdtest.ado

 Stata command "thresholdtest" computes a test for a threshold in linear 
 regression allowing for heteroskedasticity.  

 In Stata, you run it by typing

 "thresholdtest y x, q(z) trim_per(p) rep(R)"


  The inputs are:
  y = dependent variable
  x = independent variables
  z = threshold variable
  p = percentage of sample to trim from ends, e.g. p = .15 (default value if option omitted)
  R = number of bootstrap, e.g., R=5000 (default value if option omitted)

**************************************************************************/
clear all
clear mata
clear matrix
set more off
duplicates drop pctile,force
duplicates drop isei,force
duplicates drop isei pctile,force
keep if eduy3==3

thresholdtest isei, q(pctile)
thresholdtest isei eduy edu_f edu_m isei_f isei_m, q(pctile) trim_per(0.15) rep(5000)
thresholdtest eduy edu_f edu_m isei_f isei_m, q(pctile)



*20220530
*thresholdreg by Hansen
use "reg_data.dta",clear

*thresholdtest y x, q(z) trim_per(p) rep(R)

thresholdtest isei loginc_pa, q(loginc_pa)
thresholdreg isei eduy edu_f edu_m isei_f isei_m, q(pctile) h(1)
thresholdreg isei pctile, q(pctile) h(1)




*20220601
*reg by pctile
foreach num of numlist 1/4{
    use reg_data.dta,clear
	keep if pctile<=`num'*25 & pctile>(`num'-1)*25
	save reg_data`num'.dta, replace
}

foreach num of numlist 1/4{
    use reg_data`num',clear
	reg eduy loginc_pa eduy_f eduy_m isei_f isei_m urban i.prov ethnic gender age 
}
1.156897
1.499183
.5225051 
-.0900469

foreach num of numlist 1/4{
    use reg_data`num',clear
	reg good eduy loginc_pa eduy_f eduy_m isei_f isei_m urban i.prov ethnic gender age age2
}
-3.725232
-4.194383
-.8920451
-1.24016


