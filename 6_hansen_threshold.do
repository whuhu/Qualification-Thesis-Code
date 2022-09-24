global path "C:\Users\huhu\Desktop\资格论文20220831\资格论文"
global D    "$path\data"      //数据文件
global Out  "$path\out"       //结果：图形和表格
cd "$D"                       //设定当前工作路径
set scheme s2color

use "$Out\reg_data_ushape.dta",clear

*hansen can be used to estimate the threshold of mediation equation
*hansen can be used to estimate the IGE
	foreach var in logisei loginc_pa eduy logisei_f logisei_m gender urban mid east age ethnic{
		drop if `var'==.
	}

thresholdtest logisei loginc_pa eduy logisei_f logisei_m gender urban mid east age ethnic, q(loginc_pa) trim_per(0.15) rep(5000)

thresholdreg logisei loginc_pa eduy logisei_f logisei_m gender urban mid east age ethnic, q(loginc_pa) h(1)





	foreach var in eduy eduy_f eduy_m loginc_pa gender urban mid east age ethnic{
		drop if `var'==.
	}
	
(eduy<-eduy_f eduy_m loginc_pa gender urban mid east age ethnic)
thresholdtest eduy eduy_f eduy_m loginc_pa gender urban mid east age ethnic, q(loginc_pa) trim_per(0.15) rep(5000)

thresholdreg eduy eduy_f eduy_m loginc_pa gender urban mid east age ethnic, q(loginc_pa) h(1)
*cohort threshold of mediation equation
******** Test for Thresholds *********

******** Threshold Estimation Based on loginc_perm_pa ********
foreach num of numlist 1/12{
	use "reg_data_cohort_`num'.dta",clear
	foreach var in isei loginc_perm_f eduy_f mid east urban ethnic gender age{
		drop if `var'==.
	}
	thresholdtest isei loginc_perm_f eduy_f mid east urban ethnic gender age, q(loginc_perm_pa) trim_per(0.15) rep(5000)
	thresholdreg isei loginc_perm_f eduy_f mid east urban ethnic gender age, q(loginc_perm_pa) h(1)

}



	use "reg_data_cohort_4.dta",clear
	foreach var in isei loginc_perm_f eduy_f mid east urban ethnic gender age{
		drop if `var'==.
	}
	thresholdtest isei loginc_perm_f eduy_f mid east urban ethnic gender age, q(loginc_perm_pa) trim_per(0.15) rep(5000)
	thresholdreg isei loginc_perm_f eduy_f mid east urban ethnic gender age, q(loginc_perm_pa) h(1)











*cohort threshold of IGE
*cond. inc
foreach num of numlist 1/12{
	use "reg_data_cohort_`num'.dta",clear
	thresholdtest loginc_perm loginc_perm_pa age age2, q(loginc_perm_pa) trim_per(0.15) rep(5000)
	thresholdreg loginc_perm loginc_perm_pa age age2, q(loginc_perm_pa) h(1)

}


*cond. eduy_f
foreach num of numlist 1/12{
	use "reg_data_cohort_`num'.dta",clear
	thresholdtest loginc_perm loginc_perm_pa age age2, q(eduy_f) trim_per(0.15) rep(5000)
	thresholdreg loginc_perm loginc_perm_pa age age2, q(eduy_f) h(1)

}

*cond. eduy_m/eduy_pa
