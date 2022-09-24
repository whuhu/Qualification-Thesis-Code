global path "C:\Users\huhu\Desktop\资格论文20220831\资格论文"
global D    "$path\data"      //数据文件
global Out  "$path\out"       //结果：图形和表格
cd "$D"                       //设定当前工作路径
set scheme s2color

use "$D\reg_data_ushape.dta",clear

//-----------------------------------isei
lpoly good pctile if eduy3==3, bwidth(10) n(100) noscatter ci
lpoly good pctile if eduy3!=3, bwidth(5) n(100) noscatter ci

twoway lpolyci  good pctile if eduy3==3, bwidth(10) n(100) clstyle(p1line)


*---------------------------try sample graph--------------------------
lpoly good pctile if eduy3==3, bwidth(10) n(100) gen(x_5_t s_5_t) se(se_5_t) nograph


replace x_5_t=ceil(x_5_t)

gen ub_5_t=s_5_t+1.96*se_5_t
gen lb_5_t=s_5_t-1.96*se_5_t

keep  x_5_t s_5_t lb_5_t ub_5_t good pctile eduy3
order x_5_t s_5_t lb_5_t ub_5_t

twoway (line s_5_t x_5_t)(line lb_5_t x_5_t, lpattern(dash) lc(black))(line ub_5_t x_5_t, lpattern(dash) lc(black)), title("High Education Child") xtitle("Parental Income Pctile") ytitle("Prob. of Child Choosing Good Occupation") legend(on) name(ushape_high_edu, replace)


graph export "$Out\fig\ushape_high_edu.png", replace
*------------------------------------------------------------------------------


*low edu
drop x_5_t s_5_t lb_5_t ub_5_t

lpoly good pctile if eduy3!=3, bwidth(10) n(100) gen(x_5_t s_5_t) se(se_5_t) nograph

replace x_5_t=ceil(x_5_t)

gen ub_5_t=s_5_t+1.96*se_5_t
gen lb_5_t=s_5_t-1.96*se_5_t

keep  x_5_t s_5_t lb_5_t ub_5_t 
order x_5_t s_5_t lb_5_t ub_5_t

twoway (line s_5_t x_5_t)(line lb_5_t x_5_t, lpattern(dash) lc(black))(line ub_5_t x_5_t, lpattern(dash) lc(black)), title("Low Education Child") xtitle("Parental Income Pctile") ytitle("Prob. of Child Choosing Good Occupation") legend(on) name(ushape_low_edu,replace)

graph export "$Out\fig\ushape_low_edu.png", replace













*--------------Others---------------------------------
*combine two graph
gr combine ushape_high_edu ushape_low_edu, ycommon








reg edu edu_f


lpoly eduy pctile if eduy3==3, bwidth(15) n(100) noscatter ci
lpoly eduy pctile if eduy3==2, bwidth(15) n(100) noscatter ci
lpoly eduy pctile if eduy3==1, bwidth(15) n(100) noscatter ci



lpoly loginc_perm loginc_perm_pa, bwidth(1) n(100) noscatter ci



lpoly good pctile if edu3==3, bwidth(15) n(100) noscatter
lpoly good pctile if edu3==2, bwidth(15) n(100) noscatter
lpoly good pctile if edu3==1, bwidth(15) n(100) noscatter
/*稳健性检验*/
*siops
use "reg_data_ushape.dta",clear
//ushape:select into good occu.    isops
gen good=0
//replace good=1 if siops>37
replace good=1 if siops>37
npregress kernel good pctile if edu3==2
npgraph,noscatter
lpoly good pctile if edu3==3,noscatter bwidth(10)


npregress kernel good pctile if eduy3==3
npgraph,noscatter
npregress kernel good pctile if eduy3==2
npgraph,noscatter
npregress kernel good pctile if eduy3==1
npgraph,noscatter



//ushape:upward transform w.r.t father or mother
use "reg_data_ushape.dta",clear
gen up=0
replace up=1 if siops>siops_f&siops>siops_m
npregress kernel up loginc_pa if edu3==3
npgraph,noscatter
lpoly up loginc_pa if edu3==3,noscatter bwidth(5)


//ushape:upward transform w.r.t father or
use "reg_data.dta",clear
gen occ_switch=0
replace occ_switch=1 if isco_1!=isco_f_1|isco_1!=isco_m_1
npregress kernel occ_switch loginc_pa if edu3==1
npgraph,noscatter
lpoly occ_switch loginc_pa if edu3==3,noscatter bwidth(0.5)


//ushape:transform itself occu. in different year
use "panel.dta",clear
duplicates tag pid,gen(dup)
drop if dup==0
sort pid survey_year
drop dup
duplicates drop pid,force
rename isco isco_earliest
keep pid isco_earliest
save "first_year_occ",replace

use "panel.dta",clear
duplicates tag pid,gen(dup)
drop if dup==0
merge m:1 pid using "first_year_occ.dta"
sort pid -survey_year
duplicates drop pid,force


gen tran=0
replace tran=1 if isco!=isco_earliest
npregress kernel tran loginc_pa if edu3==1
npgraph,noscatter
lpoly tran loginc_pa if edu3==3,noscatter bwidth(0.5)








/*probit is not feasible
probit good loginc_pa i.edu3 edu_f edu_m age gender
predict pr
lpoly pr loginc_pa if edu3==1,noscatter bwidth(1)
npregress kernel pr loginc_pa if edu3==3
npgraph,noscatter
*/
probit good pctile i.edu3 edu_f edu_m age gender i.prov urban
predict pr
lpoly pr pctile if edu3==3,noscatter bwidth(1)
npregress kernel pr pctile if edu3==3
npgraph,noscatter


twoway (scatter pr loginc_pa if edu3==3) (lpoly pr loginc_pa if edu3==1)


//probit occu income_f i.edu
gen occ_switch=1
replace occ_switch=0 if isco_1==isco_f_1

probit occ_switch loginc_f i.edu isei_f i.edu_f
predict pr
lpoly pr loginc_f if edu3==3,noscatter bwidth(0.5)
twoway (scatter pr loginc_f if edu3==3) (lpoly pr loginc_f if edu3==3)
sc pr loginc_f if edu3==3
lpoly occ_switch loginc_f if edu3==3, n(100)

probit occ_switch loginc_f i.edu3 isei_f i.edu_f
predict pr
lpoly pr loginc_f if edu==7
sc pr loginc_f if edu3==3
lpoly occ_switch loginc_f if edu3==3, n(100)




lpoly isei loginc_f if edu==3


probit occ_switch income_f isei_f i.edu i.edu3
predict pr
lpoly pr income_f if edu==5
lpoly occ_switch income_f if edu==5

sc isei loginc_f if edu3==1


//isei ushape
drop if isei==-8|isei==-9
gen diff=isei-isei_f
gen high=0
replace high=1 if diff>0

probit high loginc_f isei_f i.edu3
predict pr
lpoly pr loginc_f if edu3==3, noscatter bwidth(0.1)

//siops ushape ***********************
drop if siops==-8
gen high=0
replace high=1 if siops>38

probit high loginc_f
predict pr
lpoly pr loginc_f if edu3==1, noscatter bwidth(0.1)


npregress kernel high loginc_f if edu3==3
npgraph,noscatter
/*2021代码--------------------------
//gen occ_switch using lpoly and npregress
gen occ_switch=1
replace occ_switch=0 if occu_isco_1==father_occu_isco_1

gen occ_switch=1
replace occ_switch=0 if occu_isco_1==father_occu_isco_1

lpoly occ_switch father_income if edu_trim==3,nosc  kernel(epan2)

npregress kernel pr income_f if edu==3
npgraph

twoway qfit occ_switch loginc_f if edu3==3
twoway qfit isei loginc_f if edu3==1
*/