global path "C:\Users\haoliang\Desktop\资格论文"
global D    "$path\data"      //数据文件
global Out  "$path\out"       //结果：图形和表格
cd "$D"                       //设定当前工作路径
set scheme s2color
**************************************************************


use "$D\reg_data_ushape.dta",clear
*20220605 use this
vc_bw good loginc_f eduy eduy_f mid east urban gender age, vcoeff(pctile)
vc_reg good loginc_f eduy eduy_f mid east urban gender age, vcoeff(pctile) klist(1(5)100)

*alternative
vc_preg good loginc_f eduy eduy_f mid east urban gender age, vcoeff(pctile) klist(1(5)100)
vc_bsreg good loginc_f eduy eduy_f mid east urban gender age, vcoeff(pctile) klist(1(5)100)


vc_graph loginc_f eduy mid east urban gender
graph combine grph1 grph2 grph3 grph4 grph5 grph6

graph export "$Out\fig\vcm.png", replace









*vc_reg
*coefficient vary with income
drop if eduy==-9
drop if prov==-9| county==-9| urban==-9

gen pctile1=pctile
**************************************************************


vc_bw good pctile eduy eduy_f eduy_m mid east urban ethnic gender age, vcoeff(pctile1)
vc_reg good pctile eduy eduy_f eduy_m isei_f isei_m mid east urban ethnic gender age, vcoeff(pctile1) klist(1(1)100)

vc_graph pctile eduy mid east urban ethnic gender
graph combine grph1 grph2 grph3 grph4 grph5 grph6







vc_bw isei pctile eduy eduy_f mid east urban gender age, vcoeff(pctile1)
vc_reg isei pctile eduy eduy_f mid east urban gender age, vcoeff(pctile1) klist(1(5)100)

vc_graph pctile eduy mid east urban gender
graph combine grph1 grph2 grph3 grph4 grph5 grph6

*calculate direct effect and indirect effect can fraction

* In all cases, two matrices e(betas) and e(stds) are saved containing the betas and standard errors for all the estimated models. This can be used for obtaining plots of the results see vc_graph
svmat e(betas),names(v)
gen d=v3/(v2+v3)
scatter d v1




keep if gender==0

reg good loginc_f eduy_f mid east urban gender age 
reg good loginc_f eduy eduy_f mid east urban gender age

reg good loginc_f eduy_f mid east urban gender age if pctile<=20
reg good loginc_f eduy eduy_f mid east urban gender age if pctile<=20

reg good loginc_f eduy_f mid east urban gender age if pctile<=40&pctile>20
reg good loginc_f eduy eduy_f mid east urban gender age if pctile<=40&pctile>20

reg good loginc_f eduy_f mid east urban gender age if pctile<=60&pctile>40
reg good loginc_f eduy eduy_f mid east urban gender age if pctile<=60&pctile>40

reg good loginc_f eduy_f mid east urban gender age if pctile<=80&pctile>60
reg good loginc_f eduy eduy_f mid east urban gender age if pctile<=80&pctile>60

reg good loginc_f eduy_f mid east urban gender age if pctile>80
reg good loginc_f eduy eduy_f mid east urban gender age if pctile>80











*inc to eduy vcm
vc_bw eduy pctile  eduy_f mid east urban ethnic gender age, vcoeff(pctile1)
vc_reg eduy pctile  eduy_f mid east urban ethnic gender age, vcoeff(pctile1) klist(1(1)100)

vc_graph pctile mid east urban ethnic gender
graph combine grph1 grph2


*edu to edu
vc_bw eduy eduy_f mid east urban ethnic gender age, vcoeff(pctile1)
vc_reg eduy eduy_f mid east urban ethnic gender age, vcoeff(pctile1) klist(1(1)100)

vc_graph pctile mid east urban ethnic gender
graph combine grph1 grph2

*occ to occ
vc_bw isei isei_f  eduy_f mid east urban ethnic gender age, vcoeff(pctile1)
vc_reg isei isei_f  eduy_f mid east urban ethnic gender age, vcoeff(pctile1) klist(1(1)100)

vc_graph pctile mid east urban ethnic gender
graph combine grph1 grph2








vc_bw isei pctile eduy eduy_f eduy_m isei_f isei_m mid east urban ethnic gender age, vcoeff(pctile1)
vc_reg isei pctile eduy eduy_f eduy_m isei_f isei_m mid east urban ethnic gender age, vcoeff(pctile1) klist(1(1)100)

vc_graph pctile eduy mid east urban ethnic gender
graph combine grph1 grph2

vc_bw logisei pctile eduy eduy_f eduy_m isei_f isei_m mid east urban ethnic gender age, vcoeff(pctile1)
vc_reg logisei pctile eduy eduy_f eduy_m isei_f isei_m mid east urban ethnic gender age, vcoeff(pctile1) klist(1(1)100)

vc_graph pctile eduy mid east urban ethnic gender
graph combine grph1 grph2



gen loginc_pa1=loginc_pa
vc_bw loginc loginc_pa eduy eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age, vcoeff(loginc_pa1)
vc_reg loginc loginc_pa eduy eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age, vcoeff(loginc_pa1) klist(1(1)100)

vc_graph loginc_pa eduy
graph combine grph1 grph2

*coefficient vary with eduy




*------
vc_bw isei pctile eduy eduy_f eduy_m age age2, vcoeff(loginc_perm_pa)
vc_reg isei pctile eduy eduy_f eduy_m age age2, vcoeff(loginc_perm_pa) klist(7(0.1)12.1)

vc_graph pctile eduy
graph combine grph1 grph2
*-------------

vc_bw loginc loginc_f eduy eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age age2, vcoeff(loginc_perm_pa)
vc_reg loginc loginc_f eduy eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age age2, vcoeff(loginc_perm_pa) klist(7(0.1)12.1)

vc_graph loginc_f eduy
graph combine grph1 grph2

reg loginc loginc_f
*-------------
vc_bw isei loginc_pa eduy eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age, vcoeff(loginc_perm_pa)
vc_reg isei loginc_pa eduy eduy_f eduy_m isei_f isei_m i.prov urban ethnic gender age, vcoeff(loginc_perm_pa) klist(7(0.1)12.1)

vc_graph loginc_pa eduy
graph combine grph1 grph2
*------
gen loginc_perm_f=log(income_permanent_f)
vc_bw loginc_perm loginc_perm_pa eduy_f eduy_m gender urban ethnic age age2, vcoeff(loginc_perm_pa)
vc_reg loginc_perm loginc_perm_pa eduy_f eduy_m gender urban ethnic age age2, vcoeff(loginc_perm_pa) klist(7(0.1)12.1)

vc_graph loginc_perm_pa
graph combine grph1 grph2
*-------------



graph export fig1.png, replace
