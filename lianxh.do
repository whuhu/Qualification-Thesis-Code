*------------------
*- 一个 dofile 范本    www.lianxh.cn
*------------------

* Version 1.1, 2020/5/10 15:04
* Author: 连家大公子
* 目的：分析家庭收入对子女学习成绩的影响

*-A. 基本设定
  global path "D:\myPaper\Income_Mark" //定义项目目录 
  // 需要预先在生成子文件夹：data, refs, out, adofiles
  global D    "$path\data"      //数据文件
  global R    "$path\refs"      //参考文献
  global Out  "$path\out"       //结果：图形和表格
  adopath +   "$path\adofiles"  //自编程序+外部命令 
  cd "$D"                       //设定当前工作路径
  set scheme s2color   

*-核心参考资料 (参考文献和文档都存放于 $R 文件夹下)
  shellout "$R\Safin_Federer_2005_Aust.pdf"

*-D1. 数据导入
  import excel using "$D\Income_Mark.xlsx", first clear
  save "_temp_"  // $D\ 可以省略，应为当前工作路径就是 $D
                 // 如果原始数据文件不大，此步骤可以省略

*-D2. 数据处理
  gen ……
  winsor2 ……
  ……
  save "data_dealed.dta", replace

*-S1. 基本描述性统计分析
  // 如果数据处理部分未作更新，可直接这里进行后续分析

  *-----表x：基本统计量-------
  use "data_dealed.dta", clear 
  local v " " //填入变量名
  local s "$Out\Table1_sum" //存储的文件名(或路径\文件名)
  logout, save("`s'") excel replace: ///
          tabstat `v', stat(mean sd p50 min max) f(%6.2f) c(s) 

  *-----表x：相关系数矩阵-------
  local v " " //填入变量名
  local s "$Out\Table2_corr" //存储的文件名(或路径\文件名)
  logout, save("`s'") excel replace: ///
          pwcorr_a `v', format(%6.2f) //star(0.05)
  
*-S2. 分组统计分析
  use "data_dealed.dta", clear  
  *-----表x：组间均值差异检验-------
  local v " " //填入变量名
  local s "$Out\ttable2" //存储的文件名(或路径\文件名)
  logout, save("`s'") excel replace: ///
          ttable2 `v', by(variable) format(%6.2f)

*-R. 回归分析
  use "data_dealed.dta", clear    
  global y   "Mark"   //被解释变量
  global x   "Income" //基本解释变量
  global z   "edu_Dad edu_Mum Age##Age ……" //基本控制变量
  global w   "i.year i.industry i.race"    //虚拟变量
 *global opt ", vce(robust)" 
  global opt ", vce(cluster industry)" 
  
  reg $y $x        $opt
  est store m1
  reg $y $x $z     $opt
  est store m2
  reg $y $x $z $w  $opt
  est store m3

  *-----表x：回归结果-------
  local s "using $Out\Table3_reg.csv"  //执行时包括这一行会输出Excel表格
  local m "m1 m2 m3"
  esttab `m' `s', nogap compress replace   ///
         b(%6.3f) s(N r2_a) drop(`drop')   ///
         star(* 0.1 ** 0.05 *** 0.01)      ///
         addnotes("*** 1% ** 5% * 10%")    ///
         indicate("行业效应 =*.industry" "年度效应 =*.year")