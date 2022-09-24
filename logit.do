cd "C:\Users\huhu\Desktop\20220109\数据"

//clear data
use "reg_data.dta",clear
//drop by occu age edu
drop if occu_isco==.|occu_isco==-8|occu_isco==8|occu_isco==-1|occu_isco==-9
drop if age<16
drop if father_age>60
drop if edu==.|edu==9|edu==-9

//drop duplicates
sort pid -survey_year
duplicates drop pid,force

keep income occu_isco occu_isei occu_siops occu_egp edu age gender father_income father_edu father_age father_occu_isco survey_year

//drop by father income
drop if father_income==-8|father_income==-9
drop if father_income>100000|income==0

//gen loginc,new occu code
gen lnfinc=log(father_income)
gen occu_isco_1=real(substr(string(occu_isco),1,1))
gen father_occu_isco_1=real(substr(string(father_occu_isco),1,1))

//gen edu trim
gen edu_trim=edu
replace edu_trim=1 if edu==1|edu==2|edu==3
replace edu_trim=2 if edu==4|edu==5
replace edu_trim=3 if edu==6|edu==7|edu==8
save "reg_1.dta",replace

**********************************************************************************************
use "reg_1.dta",clear

mlogit occu_isco_1 father_income i.edu,base(1)
predict p*
sort father_income

local names = ""
forvalues j = 1(1)9{
	forvalues i = 1(1)3{
		twoway (line p`i' father_income if edu==`j'),ytitle("") xtitle("") title(`i'th occ. of edu`j')
		 graph save `i'`j',replace
		 local names = "`names'" + "`i'`j'.gph "
}

}

graph combine `names', cols(3)

**********************************************************************************************
use "reg_1.dta",clear

mlogit occu_isco_1 father_income i.edu_trim,base(1)
predict p*
sort father_income

local names = ""
forvalues j = 1(1)3{
	forvalues i = 7(1)9{
		twoway (line p`i' father_income if edu_trim==`j'),ytitle("") xtitle("") title(`i'th occ. of edu`j')
		 graph save `i'`j',replace
		 local names = "`names'" + "`i'`j'.gph "
}

}

graph combine `names', cols(3)
**********************************************************************************************
use "reg_1.dta",clear

mlogit occu_isco_1 lnfinc i.edu,base(1)
predict p*
sort lnfinc

local names = ""
forvalues j = 1(1)9{
	forvalues i = 1(1)3{
		twoway (line p`i' lnfinc if edu==`j'),ytitle("") xtitle("") title(`i'th occ. of edu`j')
		 graph save `i'`j',replace
		 local names = "`names'" + "`i'`j'.gph "
}

}

graph combine `names', cols(3)

**********************************************************************************************
use "reg_1.dta",clear

mlogit occu_isco_1 lnfinc i.edu_trim,base(1)
predict p*
sort lnfinc

local names = ""
forvalues j = 1(1)3{
	forvalues i = 1(1)3{
		twoway (line p`i' lnfinc if edu_trim==`j'),ytitle("") xtitle("") title(`i'th occ. of edu`j')
		 graph save `i'`j',replace
		 local names = "`names'" + "`i'`j'.gph "
}

}

graph combine `names', cols(3)





