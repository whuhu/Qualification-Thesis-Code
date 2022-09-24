global path "C:\Users\haoliang\Desktop\资格论文"
global D    "$path\data"      //数据文件
global Out  "$path\out"       //结果：图形和表格
cd "$D"                       //设定当前工作路径
set scheme s2color

use "$D\reg_data_ushape.dta",clear

keep loginc_pa eduy logisei
drop if loginc_pa==.
drop if eduy==.
drop if logisei==.

save 3D.dta ,replace
export excel using "3D_matlab.xlsx", firstrow(var) replace

graph3d loginc_pa eduy logisei, ///
cuboid innergrid colorscheme(cr) xang(10) yang(292) blv ///
coord(4 5 7 8) format("%12.0fc") mark equi markeroptions(msize(1))