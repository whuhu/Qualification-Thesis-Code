global path "C:\Users\haoliang\Desktop\资格论文"
global D    "$path\data"      //数据文件
global Out  "$path\out"       //结果：图形和表格
cd "$D"                       //设定当前工作路径
set scheme s2color

//-----------------------------------isei 
use "reg_data_ushape.dta",clear

*descriptive statistic
local varlist "loginc isei eduy age gender urban ethnic loginc_pa eduy_f eduy_m"
estpost summarize `varlist', detail
esttab using Myfile.rtf,  ///
	cells("count mean(fmt(2)) sd(fmt(2)) min(fmt(2)) p50(fmt(2)) max(fmt(2))") ///
	noobs compress replace title(esttab_Table: Descriptive statistics)


*density plot for parental income
kdensity pctile if eduy3== 3, generate(x1  d1)
kdensity pctile if eduy3!= 3, generate(x2  d2)
kdensity pctile, generate(x3  d3)

gen zero = 0

twoway rarea d1 zero x1, color("black%30") ///
   ||  rarea d2 zero x2, color("gray%30") ///
   ||  rarea d3 zero x3, color("blue%20") ///
       title("Smoothed income density by education") ///
       ytitle("Smoothed income density") ///
	   xtitle("Parental income pctile") ///
       legend(ring(0) pos(10) col(1) order(1 "High Edu" 2 "Low Edu" 3 "Full Sample"))    
	   
graph export smoothed_income_density.png, replace


*