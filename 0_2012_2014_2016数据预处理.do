global path "C:\Users\haoliang\Desktop\资格论文"
global D    "$path\data"      //数据文件
global Out  "$path\out"       //结果：图形和表格
cd "$D"                       //设定当前工作路径
set scheme s2color   

//use cfps code to execute 1 2
//1.	2012年的个人库生成ISCO及职业威望变量
//2.	2014年的个人库生成ISCO及职业威望变量
//3.	2016年的个人库匹配将个人与其父母的pid匹配起来
/*
使用家庭关系库merge

    Result                           # of obs.
    -----------------------------------------
    not matched                        21,287
        from master                         0  (_merge==1)
        from using                     21,287  (_merge==2)

    matched                            36,892  (_merge==3)
-----------------------------------------
*/
*补齐2012民族变量
cd "$path\data"
use 2010,clear
keep pid qa5code
rename qa5code ethnic
save "2010_ethnic",replace

use 2012,clear
merge 1:1 pid using 2010_ethnic
replace qa701code=ethnic if (_merge==3 & qa701code==-8)|(_merge==3 & qa701code==.)
drop if _merge==2
drop _merge ethnic
save 2012,replace

*补齐2014民族变量
use 2012,clear
keep pid qa701code
rename qa701code ethnic
save "2012_ethnic",replace

use 2014,clear
merge 1:1 pid using 2012_ethnic
replace qa701code=ethnic if (_merge==3 & qa701code==-8)|(_merge==3 & qa701code==.)
drop if _merge==2
drop _merge ethnic

merge 1:1 pid using 2010_ethnic
replace qa701code=ethnic if (_merge==3 & qa701code==-8)|(_merge==3 & qa701code==.)
drop if _merge==2
drop _merge ethnic
save 2014,replace


*2016年的个人库匹配将个人与其父母的pid匹配起来
cd "E:\Data Base\CFPS\CFPS 2016"

use "cfps2016famconf_201804.dta",clear
keep pid pid_f pid_m
save "id.dta",replace

use "cfps2016adult_201906.dta",clear
merge 1:1 pid using id.dta
drop _merge
save "2016",replace

*补齐2016民族变量
cd "C:\Users\huhu\Desktop\资格论文\data"
use 2014,clear
keep pid qa701code
rename qa701code ethnic
save "2014_ethnic",replace

use 2016,clear
merge 1:1 pid using 2014_ethnic
replace pa701code=ethnic if (_merge==3 & pa701code==-8)|(_merge==3 & pa701code==.)
drop if _merge==2
drop _merge ethnic

merge 1:1 pid using 2012_ethnic
replace pa701code=ethnic if (_merge==3 & pa701code==-8)|(_merge==3 & pa701code==.)
drop if _merge==2
drop _merge ethnic

merge 1:1 pid using 2010_ethnic
replace pa701code=ethnic if (_merge==3 & pa701code==-8)|(_merge==3 & pa701code==.)
drop if _merge==2
drop _merge ethnic
save 2016,replace

*补齐2018民族变量
cd "C:\Users\huhu\Desktop\资格论文\data"
use 2016,clear
keep pid pa701code
rename pa701code ethnic
save "2016_ethnic",replace

use 2018,clear
merge 1:1 pid using 2016_ethnic
replace qa701code=ethnic if (_merge==3 & qa701code==-8)|(_merge==3 & qa701code==.)
drop if _merge==2
drop _merge ethnic

merge 1:1 pid using 2014_ethnic
replace qa701code=ethnic if (_merge==3 & qa701code==-8)|(_merge==3 & qa701code==.)
drop if _merge==2
drop _merge ethnic

merge 1:1 pid using 2012_ethnic
replace qa701code=ethnic if (_merge==3 & qa701code==-8)|(_merge==3 & qa701code==.)
drop if _merge==2
drop _merge ethnic

merge 1:1 pid using 2010_ethnic
replace qa701code=ethnic if (_merge==3 & qa701code==-8)|(_merge==3 & qa701code==.)
drop if _merge==2
drop _merge ethnic

save 2018,replace




/*
cd "C:\Users\huhu\Desktop\资格论文\data"
use "2020.dta",clear
keep if xchildpid_a_1!=.&xchildpid_a_1!=-8
reshape long xchildpid_a_,i(pid)

keep if gender==1
rename pid pid_f
rename xchildpid_a_ pid

drop if pid ==.|pid==-8
duplicates drop pid pid_f,force
drop _j
keep pid pid_f
duplicates drop pid,force
save "2020_pair_id_f",replace

use "2020.dta",clear
keep if xchildpid_a_1!=.&xchildpid_a_1!=-8
reshape long xchildpid_a_,i(pid)

keep if gender==0
rename pid pid_m
rename xchildpid_a_ pid

drop if pid ==.|pid==-8
duplicates drop pid pid_m,force
drop _j
keep pid pid_m
duplicates drop pid,force
save "2020_pair_id_m",replace

use "2020.dta",clear
merge m:1 pid using 2020_pair_id_f
rename _merge _merge1
merge m:1 pid using 2020_pair_id_m
keep if _merge==3|_merge1==3
drop _merge _merge1
save "2020",replace

*cfps2020个人库不包含职业信息





