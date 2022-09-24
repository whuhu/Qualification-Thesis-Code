global path "C:\Users\haoliang\Desktop\资格论文"
global D    "$path\data"      //数据文件
global Out  "$path\out"       //结果：图形和表格
cd "$D"                       //设定当前工作路径
set scheme s2color

use "$D\reg_data_ushape.dta",clear

gen male=1
replace male=0 if gender==0
keep loginc_perm loginc_perm_f age age_f age2 age_f2
drop if loginc_perm==.
drop if loginc_perm_f==.

export delimited "$Out\ushape.csv",replace

*-------------more variables----------------------
gen male=1
replace male=0 if gender==0
keep good loginc_perm_f eduy eduy_f mid east urban male age
drop if loginc_perm==.
drop if loginc_perm_f==.
drop if urban==.
drop if eduy_f==.
drop if eduy==.

export delimited "$Out\ushape_vcm.csv",replace

*-------------more variables----------------------
gen male=1
replace male=0 if gender==0
keep loginc_perm loginc_perm_pa age age_f age2 age_f2 income_permanent_pa eduy logisei male urban

export delimited "$Out\ushape_1.csv",replace