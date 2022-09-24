cd "C:\Users\huhu\Desktop\资格论文\data"

//-----------------------------------isei 
use "reg_data_ushape.dta",clear
gen pctile2=pctile^2

probit good pctile pctile2
predict pr

sort pctile

local names = ""
forvalues j = 1(1)9{
	forvalues i = 1(1)3{
		twoway (line p`i' father_income if edu==`j'),ytitle("") xtitle("") title(`i'th occ. of edu`j')
		 graph save `i'`j',replace
		 local names = "`names'" + "`i'`j'.gph "
}

}

graph combine `names', cols(3)
line pr pctile if eduy3==0


use "reg_data_ushape.dta",clear
gen pctile2=pctile^2

keep if eduy3==3
probit good pctile pctile2
predict pr

margins, dydx(pctile) at(pctile=2)
margins, dydx(pctile) at(pctile=80)

margins, dydx(pctile) at(pctile = (5(5) 90)) vsquish






*USHAPE CODE FOR PROBIT
use "reg_data_ushape.dta",clear

gen pctile_1=pctile/100
gen pctile2_1=pctile_1*pctile_1


probit good pctile_1 pctile2_1 if eduy3==1
nlcom (b: (normalden(_b[_cons]))*(_b[pctile_1])), post
matrix beta_occ_all=e(b)
gen b=beta_occ_all[1,1] if eduy3==3


probit good pctile_1 pctile2_1 if eduy3==1
nlcom (b2c: (normalden(_b[_cons]+_b[pctile_1]+_b[pctile2_1]))*(_b[pctile_1]+2*_b[pctile2_1])), post


