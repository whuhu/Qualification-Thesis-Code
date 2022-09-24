cd "C:\Users\huhu\Desktop\20220109\数据"

use "reg.dta",clear
keep qg303code_isco qg303code_isei qg303code_siops qg303code_egp income cfps2018edu income_f

//descriptive stat
*describe,fullnames

//--------------------------------------------------
drop if qg303code_isco==-1|qg303code_isco==-8|qg303code_isco==-9|qg303code_isco==.
//gen the first digit of isco
gen qg303code_isco_1=real(substr(string(qg303code_isco),1,1))

//gen the isco skill level
gen qg303code_isco_skill=qg303code_isco_1
replace qg303code_isco_skill=1 if qg303code_isco_1==9
replace qg303code_isco_skill=2 if qg303code_isco_1==4|qg303code_isco_1==5|qg303code_isco_1==6|qg303code_isco_1==7|qg303code_isco_1==8
replace qg303code_isco_skill=3 if qg303code_isco_1==2|qg303code_isco_1==3
replace qg303code_isco_skill=4 if qg303code_isco_1==1


gen cfps2018edu_trim=cfps2018edu
replace cfps2018edu_trim=1 if cfps2018edu_trim==2|cfps2018edu_trim==3
replace cfps2018edu_trim=2 if cfps2018edu_trim==4|cfps2018edu_trim==5
replace cfps2018edu_trim=3 if cfps2018edu_trim==6|cfps2018edu_trim==7


//drop edu level and income level
drop if cfps2018edu==1|cfps2018edu==8
drop if income_f>120000|income_f==0
save "reg_mlogit.dta", replace



//reg isco_1(9 category) income_f edu(6 category)
use "reg_mlogit.dta",clear
mlogit qg303code_isco_1 income_f i.cfps2018edu
predict p*
sort income_f


local names = ""
forvalues j = 2(1)7{
	forvalues i = 7(1)9{
		twoway (line p`i' income_f if cfps2018edu==`j'),ytitle("") xtitle("") title(`i'th occ. of edu`j')
		 graph save `i'`j',replace
		 local names = "`names'" + "`i'`j'.gph "
}

}

graph combine `names', cols(3)











//reg isco_skill(4 category) income_f edu(6 category)
use "reg_mlogit.dta",clear
mlogit qg303code_isco_skill income_f i.cfps2018edu
predict p*
sort income_f


local names = ""
forvalues j = 2(1)7{
	forvalues i = 1(1)4{
		twoway (line p`i' income_f if cfps2018edu==`j'),ytitle("") xtitle("") title(`i'th occ. of edu`j')
		 graph save `i'`j',replace
		 local names = "`names'" + "`i'`j'.gph "
}

}

graph combine `names', cols(4)


*margin plot
keep if cfps2018edu==3
margins income_f, atmeans predict(outcome(1))
marginsplot, name(general)

margins, at(income_f=(0(1000) 120000)) predict(outcome(3)) vsquish
marginsplot


//reg isco_skill(4 category) income_f edu(3 category)
use "reg_mlogit.dta",clear

mlogit qg303code_isco_skill income_f i.cfps2018edu_trim
predict p*
sort income_f


local names = ""
forvalues j = 1/3{
	forvalues i = 1(1)4{
		twoway (line p`i' income_f if cfps2018edu_trim==`j'),ytitle("") xtitle("") title(`i'th occ. of edu_trim`j')
		 graph save `i'`j',replace
		 local names = "`names'" + "`i'`j'.gph "
}

}

graph combine `names', cols(4)





//reg qg303code_egp(4 category) income_f edu(3 category)
/*Categories:
	  1 "higher controllers"
	  2 "lo controllers"
	  3 "routine nonmanual"
	  4 "sempl with emp"
	  5 "sempl without empl"
	  7 "manual supervisor"
	  8 "skilled manual"
	  9 "semi-unskilld manual"
	 10 "farm labor"
	 11 "selfempl farm"
	 */


use "reg_mlogit.dta",clear
drop if qg303code_egp==-8

gen qg303code_egp_trim=qg303code_egp
replace qg303code_egp_trim=1 if qg303code_egp==1|qg303code_egp==2|qg303code_egp==4|qg303code_egp==5
replace qg303code_egp_trim=2 if qg303code_egp==3
replace qg303code_egp_trim=3 if qg303code_egp==7|qg303code_egp==8
replace qg303code_egp_trim=4 if qg303code_egp==9
replace qg303code_egp_trim=5 if qg303code_egp==10|qg303code_egp==11


mlogit qg303code_egp_trim income_f i.cfps2018edu_trim
predict p*
sort income_f

twoway line p1 income_f if cfps2018edu_trim==1
local names = ""
forvalues j = 1/3{
	forvalues i = 1(1)5{
		twoway (line p`i' income_f if cfps2018edu_trim==`j'),ytitle("") xtitle("") title(`i'th occ. of edu_trim`j')
		 graph save `i'`j',replace
		 local names = "`names'" + "`i'`j'.gph "
}

}

graph combine `names', cols(5)




//reg isco_skill(4 category) income_f edu(3 category)
use "reg_mlogit.dta",clear

mlogit qg303code_isco_skill income_f i.cfps2018edu_trim
predict p*
sort income_f


local names = ""
forvalues j = 2(1)7{
	forvalues i = 1(1)4{
		twoway (line p`i' income_f if cfps2018edu==`j'),ytitle("") xtitle("") title(`i'th occ. of edu`j')
		 graph save `i'`j',replace
		 local names = "`names'" + "`i'`j'.gph "
}

}

graph combine `names', cols(4)





//reg qg303code_egp(4 category) income_f edu(3 category)
use "reg_mlogit.dta",clear
drop if qg303code_egp==-8

gen qg303code_egp_trim=qg303code_egp
replace qg303code_egp_trim=1 if qg303code_egp_trim==1|qg303code_egp_trim==2
replace qg303code_egp_trim=2 if qg303code_egp_trim==3|qg303code_egp_trim==4|qg303code_egp_trim==5
replace qg303code_egp_trim=3 if qg303code_egp_trim==7|qg303code_egp_trim==8|qg303code_egp_trim==9
replace qg303code_egp_trim=4 if qg303code_egp_trim==10|qg303code_egp_trim==11


mlogit qg303code_egp_trim income_f i.cfps2018edu_trim
predict p*
sort income_f


local names = ""
forvalues j = 1/3{
	forvalues i = 1(1)4{
		twoway (line p`i' income_f if cfps2018edu_trim==`j'),ytitle("") xtitle("") title(`i'th occ. of edu_trim`j')
		 graph save `i'`j',replace
		 local names = "`names'" + "`i'`j'.gph "
}

}

graph combine `names', cols(4)




use "reg_mlogit.dta",clear
mlogit qg303code_isco_1 income_f i.cfps2018edu_trim
sort income_f
predict p*
twoway (line p8 income_f if cfps2018edu_trim==1)






















use "reg_mlogit.dta",clear
gen id=_n
cmset qg303code_isco_1
mixlogit qg303code_isco_1 income_f,gr(cfps2018edu) rand(income_f)
//------------------------------------------------------------

margins, at(income_f = (0 (1000) 200000)) predict(outcome(1)) vsquish
margins, at(income_f = (0 (1000) 200000)) predict(outcome(1)) vsquish
margins, at(income_f = (0 (1000) 200000)) predict(outcome(1)) vsquish

predict p*
sort income_f
twoway (line p1 income_f),ytitle("") xtitle("") title("Legislators, senior officials and managers") saving(p1)

twoway (line p2 income_f),ytitle("") xtitle("") title("Professionals") saving(p2)

twoway (line p3 income_f),ytitle("") xtitle("") title("Technicians and associate professionals") saving(p3)

twoway (line p4 income_f),ytitle("") xtitle("") title("Clerks") saving(p4)

twoway (line p5 income_f),ytitle("") xtitle("") title("Service workers and shop and market sales workers") saving(p5)

twoway (line p6 income_f),ytitle("") xtitle("") title("Skilled agricultural and fishery workers") saving(p6)

twoway (line p7 income_f),ytitle("") xtitle("") title("Craft and related trades workers") saving(p7)

twoway (line p8 income_f),ytitle("") xtitle("") title("Plant and machine operators and assemblers") saving(p8)

twoway (line p9 income_f),ytitle("") xtitle("") title("Elementary occupations ") saving(p9)

gr combine p1.gph p2.gph p3.gph p4.gph p5.gph p6.gph p7.gph p8.gph p9.gph
	
	
	
	
	
	
	
	
//SEM
sem (qg303code_egp_trim <- cfps2018edu_trim income_f) (cfps2018edu_trim <- income_f)   //进行模型估计
estat teffects

outreg2 using sem.doc,replace tstat ctitle(y) bdec(3) tdec(2) addtext(SEM without threshold)


estat teffects,   coeflegend //here's is a key or legend showing how you can get access each effect in the output
estat teffects,   standardized  //I'll assume you want the std versions of these
return li  //here are all the things you can export to excel after estat teffects
ereturn li //and here
mat li e(b_std)
matrix I =r(indirect_std)
mat li I

putexcel set results.xls, replace
putexcel A1 = matrix(I) //you'll have to make any transformations before exporting, or export one cell at a time and put it where you'd like.
putexcel close
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
