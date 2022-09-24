cd "C:\Users\huhu\Desktop\资格论文\data"

use "reg_data_ushape.dta",clear
gen logisei_f=log(isei_f)
gen logisei_m=log(isei_m)


*分组回归系数
reg loginc loginc_f age age2

reg loginc loginc_f age age2 age_f age_f2 if gender==1
reg loginc loginc_f age age2 age_f age_f2 if gender==0

reg loginc loginc_f age age2 age_f age_f2 if urban==1
reg loginc loginc_f age age2 age_f age_f2 if urban==0

reg loginc loginc_f age age2 age_f age_f2 if west==1
reg loginc loginc_f age age2 age_f age_f2 if mid==1
reg loginc loginc_f age age2 age_f age_f2 if east==1


import excel "inc_by_group.xlsx", firstrow clear
destring coef se up low, replace force
#delimit ;
twoway (scatter n1 coef , 
       ytit( "Effects of father income on children income") 
       ylabel(-12(12)0 0 " " -12 " ") 
       mlabel(sample) 
       mlabp(13) 
       xlabel(-0.1(0.1).6, grid) 
       xline(0, lp(dash))) 
	   
       (rcap up low n1 ,  
		lp(dash)  
       xscale(alt)  
       xtit("Coef. and 95% CIs in different samples")  
       legend(label(1 "Coef.") label(2 "95% CI")  
              col(1) ring(0) pos(1) size(small))   
       hori 
       text(-1 -0.1 "Panel A: Full Sample",place(e))  
       text(-3 -0.1 "Panel B: By Gender",place(e)) 
       text(-6 -0.1 "Panel C: By Registered Residence",place(e))
	   text(-9 -0.1 "Panel C: By Geographical Location",place(e))) 

;
#delimit cr
*-------------------------------------Figure3b-----------------over------------
gr export "C:\Users\huhu\Desktop\资格论文\fig\inc_by_group.png",replace 
restore     /*-----------0ver----------*/












*inc
reg loginc_perm loginc_perm_f age age2 age_f age_f2

reg loginc_perm logisei_f age age2 age_f age_f2

reg loginc_perm eduy_f age age2 age_f age_f2



*occ
reg logisei logisei_f








*edu
reg eduy eduy_f



*inc+control
reg loginc_perm loginc_perm_f age age2 age_f age_f2

reg loginc_perm loginc_perm_f age age2 age_f age_f2

reg loginc_perm loginc_perm_f age age2 age_f age_f2
