global path "C:\Users\huhu\Desktop\资格论文20220831\资格论文"
global D    "$path\data"      //数据文件
global Out  "$path\out"       //结果：图形和表格
cd "$D"                       //设定当前工作路径
set scheme s2color

use "$D\unclean_hu.dta",clear

*adjust income
replace income=income/1.083 if survey_year==2012
replace income=income/1.133 if survey_year==2014
replace income=income/1.172 if survey_year==2016
replace income=income/1.216 if survey_year==2018


*gen west mid east
gen west=0
gen mid=0
gen east=0

replace west=1 if prov==50|prov==51|prov==52|prov==53|prov==54|prov==61|prov==62|prov==63|prov==64|prov==65
replace mid=1 if prov==14|prov==15|prov==22|prov==23|prov==34|prov==36|prov==41|prov==42|prov==43
replace east=1 if prov==11|prov==12|prov==13|prov==21|prov==31|prov==32|prov==33|prov==35|prov==37|prov==44|prov==45|prov==46

save "unclean_hu_1.dta",replace


use "unclean_hu_1.dta",clear
//sort pid -survey_year
//duplicates drop pid,force
keep pid_f survey_year
drop if pid_f==-8
rename pid_f pid
duplicates drop pid survey_year,force
save "pid_f.dta",replace

use "unclean_hu_1.dta",clear
//sort pid -survey_year
//duplicates drop pid,force
keep pid_m survey_year
drop if pid_m==-8
rename pid_m pid
duplicates drop pid survey_year,force
save "pid_m.dta",replace


//use father id find father income
use "unclean_hu_1.dta",clear
merge m:1 pid survey_year using "pid_f.dta"
keep if _merge==3
drop _merge
drop index pid_f pid_m
drop if age>60

gen income_c=income
replace income_c=. if income_c<0

*calculate permanent income
sort pid
by pid: egen income_permanent=mean(income_c)

keep pid income age edu eduy isco isei siops survey_year income_permanent
//clean income age

rename pid pid_f
rename income income_f
rename age age_f
rename edu edu_f
rename eduy eduy_f
rename isco isco_f
rename isei isei_f
rename siops siops_f
rename income_permanent income_permanent_f
save "father_data.dta",replace


//use mother id find mother income
use "unclean_hu_1.dta",clear
merge m:1 pid survey_year using "pid_m.dta"
keep if _merge==3
drop _merge
//clean income age
drop if age>60

gen income_c=income
replace income_c=. if income_c<0

*calculate permanent income
sort pid
by pid: egen income_permanent=mean(income_c)

keep pid income age edu eduy isco isei siops survey_year income_permanent

rename pid pid_m
rename income income_m
rename age age_m
rename edu edu_m
rename eduy eduy_m
rename isco isco_m
rename isei isei_m
rename siops siops_m
rename income_permanent income_permanent_m
save "mother_data.dta",replace


//merge individual with father
use "unclean_hu_1.dta",clear
merge m:1 pid_f survey_year using "father_data.dta"
rename _merge merge_f

merge m:1 pid_m survey_year using "mother_data.dta"
rename _merge merge_m
drop if merge_f==1&merge_m==1
gen merge=merge_f+merge_m

drop index

***clear data***
//---------------------------
//clean data
drop if age<16|age>45
*drop if occu==. |occu==-1|occu==-2|occu==-7|occu==-8|occu==-9|occu==999999
*drop if edu==-9
*drop if eduy==-9

//clean income
gen income_pa=income_f+income_m
gen income_permanent_pa=income_permanent_f+income_permanent_m
*可以尝试插值补充父母收入
*drop if income_pa<=0


*winsor income_pa
*winsor income_pa, g(xx) p(0.01)
*replace income_pa=xx
*drop xx

*drop if income_pa>105000|income_pa<6000
sort pid
by pid: egen income_permanent=mean(income)

gen loginc=log(income)
gen loginc_f=log(income_f)
gen loginc_m=log(income_m)
gen loginc_pa=ln(income_pa)
gen loginc_perm_pa=ln(income_permanent_pa)
gen loginc_perm_f=log(income_permanent_f)
gen loginc_perm_m=log(income_permanent_m)
gen loginc_perm=log(income_permanent)

gen logisei=log(isei)
gen logisei_f=log(isei_f)
gen logisei_m=log(isei_m)

gen age2=age^2
gen age_f2=age_f^2
gen age_m2=age_m^2

//gen edu_3
gen edu3=1
replace edu3=2 if edu==4|edu==5
replace edu3=3 if edu==6|edu==7|edu==8

gen eduy3=1
replace eduy3=2 if eduy>9&eduy<16
replace eduy3=3 if eduy>15


//gen 1-digit isco
gen isco_1=real(substr(string(isco),1,1))
gen isco_f_1=real(substr(string(isco_f),1,1))
gen isco_m_1=real(substr(string(isco_f),1,1))

replace ethnic=0 if ethnic!=1&ethnic!=-8


sort pid pid_f pid_m -survey_year

label define xingbie 0 "女性" 1 "男性"
label values gender xingbie

label define minzu 0 "少数民族" 1 "汉族"
label values ethnic minzu


*get birth cohort
gen birth_year=.
replace birth_year=2010-age if survey_year==2010
replace birth_year=2012-age if survey_year==2012
replace birth_year=2014-age if survey_year==2014
replace birth_year=2016-age if survey_year==2016
replace birth_year=2018-age if survey_year==2018

save "$Out\panel.dta",replace


*drop survey_year
*drop if prov==-9| county==-9| urban==-9


*retain the latest obs.
save "reg_data.dta",replace


*gen pctile rank
set more off
use "reg_data.dta",clear

replace isei=. if isei<0
replace income=. if income<0
replace gender=. if gender<0
replace urban=. if urban<0
replace ethnic=. if ethnic<0
replace eduy=. if eduy<0

drop if occu==. |occu==-1|occu==-2|occu==-7|occu==-8|occu==-9|occu==999999
drop if isei==.

*------------------good threshold--------------------------
gen good=0
replace good=1 if isei>35


drop if income_pa<6000
drop if income_pa>200000
drop if income_pa==.
duplicates drop pid,force



*cut 1% extreme
egen dec05=pctile(income_pa), p(0.5)
egen dec995=pctile(income_pa), p(99.5)

drop if income_pa<dec05|income_pa>dec995
drop dec05 dec995


****************************************************************************
*****************************************************************************

***generating percentiles**************************

*making original kind of deciles
egen dec1=pctile(income_pa), p(1)
egen dec2=pctile(income_pa), p(2)
egen dec3=pctile(income_pa), p(3)
egen dec4=pctile(income_pa), p(4)
egen dec5=pctile(income_pa), p(5)
egen dec6=pctile(income_pa), p(6)
egen dec7=pctile(income_pa), p(7)
egen dec8=pctile(income_pa), p(8)
egen dec9=pctile(income_pa), p(9)

egen dec10=pctile(income_pa), p(10)
egen dec11=pctile(income_pa), p(11)
egen dec12=pctile(income_pa), p(12)
egen dec13=pctile(income_pa), p(13)
egen dec14=pctile(income_pa), p(14)
egen dec15=pctile(income_pa), p(15)
egen dec16=pctile(income_pa), p(16)
egen dec17=pctile(income_pa), p(17)
egen dec18=pctile(income_pa), p(18)
egen dec19=pctile(income_pa), p(19)

egen dec20=pctile(income_pa),  p(20)
egen dec21=pctile(income_pa),  p(21)
egen dec22=pctile(income_pa),  p(22)
egen dec23=pctile(income_pa),  p(23)
egen dec24=pctile(income_pa),  p(24)
egen dec25=pctile(income_pa),  p(25)
egen dec26=pctile(income_pa),  p(26)
egen dec27=pctile(income_pa),  p(27)
egen dec28=pctile(income_pa),  p(28)
egen dec29=pctile(income_pa),  p(29)

egen dec30=pctile(income_pa),  p(30)
egen dec31=pctile(income_pa),  p(31)
egen dec32=pctile(income_pa),  p(32)
egen dec33=pctile(income_pa),  p(33)
egen dec34=pctile(income_pa),  p(34)
egen dec35=pctile(income_pa),  p(35)
egen dec36=pctile(income_pa),  p(36)
egen dec37=pctile(income_pa),  p(37)
egen dec38=pctile(income_pa),  p(38)
egen dec39=pctile(income_pa),  p(39)

egen dec40=pctile(income_pa),  p(40)
egen dec41=pctile(income_pa),  p(41)
egen dec42=pctile(income_pa),  p(42)
egen dec43=pctile(income_pa),  p(43)
egen dec44=pctile(income_pa),  p(44)
egen dec45=pctile(income_pa),  p(45)
egen dec46=pctile(income_pa),  p(46)
egen dec47=pctile(income_pa),  p(47)
egen dec48=pctile(income_pa),  p(48)
egen dec49=pctile(income_pa),  p(49)

egen dec50=pctile(income_pa),  p(50)
egen dec51=pctile(income_pa),  p(51)
egen dec52=pctile(income_pa),  p(52)
egen dec53=pctile(income_pa),  p(53)
egen dec54=pctile(income_pa),  p(54)
egen dec55=pctile(income_pa),  p(55)
egen dec56=pctile(income_pa),  p(56)
egen dec57=pctile(income_pa),  p(57)
egen dec58=pctile(income_pa),  p(58)
egen dec59=pctile(income_pa),  p(59)

egen dec60=pctile(income_pa),  p(60)
egen dec61=pctile(income_pa),  p(61)
egen dec62=pctile(income_pa),  p(62)
egen dec63=pctile(income_pa),  p(63)
egen dec64=pctile(income_pa),  p(64)
egen dec65=pctile(income_pa),  p(65)
egen dec66=pctile(income_pa),  p(66)
egen dec67=pctile(income_pa),  p(67)
egen dec68=pctile(income_pa),  p(68)
egen dec69=pctile(income_pa),  p(69)

egen dec70=pctile(income_pa),  p(70)
egen dec71=pctile(income_pa),  p(71)
egen dec72=pctile(income_pa),  p(72)
egen dec73=pctile(income_pa),  p(73)
egen dec74=pctile(income_pa),  p(74)
egen dec75=pctile(income_pa),  p(75)
egen dec76=pctile(income_pa),  p(76)
egen dec77=pctile(income_pa),  p(77)
egen dec78=pctile(income_pa),  p(78)
egen dec79=pctile(income_pa),  p(79)

egen dec80=pctile(income_pa),  p(80)
egen dec81=pctile(income_pa),  p(81)
egen dec82=pctile(income_pa),  p(82)
egen dec83=pctile(income_pa),  p(83)
egen dec84=pctile(income_pa),  p(84)
egen dec85=pctile(income_pa),  p(85)
egen dec86=pctile(income_pa),  p(86)
egen dec87=pctile(income_pa),  p(87)
egen dec88=pctile(income_pa),  p(88)
egen dec89=pctile(income_pa),  p(89)

egen dec90=pctile(income_pa),  p(90)
egen dec91=pctile(income_pa),  p(91)
egen dec92=pctile(income_pa),  p(92)
egen dec93=pctile(income_pa),  p(93)
egen dec94=pctile(income_pa),  p(94)
egen dec95=pctile(income_pa),  p(95)
egen dec96=pctile(income_pa),  p(96)
egen dec97=pctile(income_pa),  p(97)
egen dec98=pctile(income_pa),  p(98)
egen dec99=pctile(income_pa),  p(99)




gen pctile=0
replace pctile=1 if income_pa<dec1
replace pctile=2 if income_pa>=dec1 & income_pa<dec2
replace pctile=3 if income_pa>=dec2 & income_pa<dec3
replace pctile=4 if income_pa>=dec3 & income_pa<dec4
replace pctile=5 if income_pa>=dec4 & income_pa<dec5
replace pctile=6 if income_pa>=dec5 & income_pa<dec6
replace pctile=7 if income_pa>=dec6 & income_pa<dec7
replace pctile=8 if income_pa>=dec7 & income_pa<dec8
replace pctile=9 if income_pa>=dec8 & income_pa<dec9
replace pctile=10 if income_pa>=dec9 & income_pa<dec10

replace pctile=11 if income_pa>=dec10 & income_pa<dec11
replace pctile=12 if income_pa>=dec11 & income_pa<dec12
replace pctile=13 if income_pa>=dec12 & income_pa<dec13
replace pctile=14 if income_pa>=dec13 & income_pa<dec14
replace pctile=15 if income_pa>=dec14 & income_pa<dec15
replace pctile=16 if income_pa>=dec15 & income_pa<dec16
replace pctile=17 if income_pa>=dec16 & income_pa<dec17
replace pctile=18 if income_pa>=dec17 & income_pa<dec18
replace pctile=19 if income_pa>=dec18 & income_pa<dec19
replace pctile=20 if income_pa>=dec19 & income_pa<dec20

replace pctile=21 if income_pa>=dec20 & income_pa<dec22
replace pctile=22 if income_pa>=dec21 & income_pa<dec22
replace pctile=23 if income_pa>=dec22 & income_pa<dec23
replace pctile=24 if income_pa>=dec23 & income_pa<dec24
replace pctile=25 if income_pa>=dec24 & income_pa<dec25
replace pctile=26 if income_pa>=dec25 & income_pa<dec26
replace pctile=27 if income_pa>=dec26 & income_pa<dec27
replace pctile=28 if income_pa>=dec27 & income_pa<dec28
replace pctile=29 if income_pa>=dec28 & income_pa<dec29
replace pctile=30 if income_pa>=dec29 & income_pa<dec30


replace pctile=31 if income_pa>=dec30 & income_pa<dec31
replace pctile=32 if income_pa>=dec31 & income_pa<dec32
replace pctile=33 if income_pa>=dec32 & income_pa<dec33
replace pctile=34 if income_pa>=dec33 & income_pa<dec34
replace pctile=35 if income_pa>=dec34 & income_pa<dec35
replace pctile=36 if income_pa>=dec35 & income_pa<dec36
replace pctile=37 if income_pa>=dec36 & income_pa<dec37
replace pctile=38 if income_pa>=dec37 & income_pa<dec38
replace pctile=39 if income_pa>=dec38 & income_pa<dec39
replace pctile=40 if income_pa>=dec39 & income_pa<dec40


replace pctile=41 if income_pa>=dec40 & income_pa<dec41
replace pctile=42 if income_pa>=dec41 & income_pa<dec42
replace pctile=43 if income_pa>=dec42 & income_pa<dec43
replace pctile=44 if income_pa>=dec43 & income_pa<dec44
replace pctile=45 if income_pa>=dec44 & income_pa<dec45
replace pctile=46 if income_pa>=dec45 & income_pa<dec46
replace pctile=47 if income_pa>=dec46 & income_pa<dec47
replace pctile=48 if income_pa>=dec47 & income_pa<dec48
replace pctile=49 if income_pa>=dec48 & income_pa<dec49
replace pctile=50 if income_pa>=dec49 & income_pa<dec50


replace pctile=51 if income_pa>=dec50 & income_pa<dec51
replace pctile=52 if income_pa>=dec51 & income_pa<dec52
replace pctile=53 if income_pa>=dec52 & income_pa<dec53
replace pctile=54 if income_pa>=dec53 & income_pa<dec54
replace pctile=55 if income_pa>=dec54 & income_pa<dec55
replace pctile=56 if income_pa>=dec55 & income_pa<dec56
replace pctile=57 if income_pa>=dec56 & income_pa<dec57
replace pctile=58 if income_pa>=dec57 & income_pa<dec58
replace pctile=59 if income_pa>=dec58 & income_pa<dec59
replace pctile=60 if income_pa>=dec59 & income_pa<dec60

replace pctile=61 if income_pa>=dec60 & income_pa<dec61
replace pctile=62 if income_pa>=dec61 & income_pa<dec62
replace pctile=63 if income_pa>=dec62 & income_pa<dec63
replace pctile=64 if income_pa>=dec63 & income_pa<dec64
replace pctile=65 if income_pa>=dec64 & income_pa<dec65
replace pctile=66 if income_pa>=dec65 & income_pa<dec66
replace pctile=67 if income_pa>=dec66 & income_pa<dec67
replace pctile=68 if income_pa>=dec67 & income_pa<dec68
replace pctile=69 if income_pa>=dec68 & income_pa<dec69
replace pctile=70 if income_pa>=dec69 & income_pa<dec70


replace pctile=71 if income_pa>=dec70 & income_pa<dec71
replace pctile=72 if income_pa>=dec71 & income_pa<dec72
replace pctile=73 if income_pa>=dec72 & income_pa<dec73
replace pctile=74 if income_pa>=dec73 & income_pa<dec74
replace pctile=75 if income_pa>=dec74 & income_pa<dec75
replace pctile=76 if income_pa>=dec75 & income_pa<dec76
replace pctile=77 if income_pa>=dec76 & income_pa<dec77
replace pctile=78 if income_pa>=dec77 & income_pa<dec78
replace pctile=79 if income_pa>=dec78 & income_pa<dec79
replace pctile=80 if income_pa>=dec79 & income_pa<dec80


replace pctile=81 if income_pa>=dec80 & income_pa<dec81
replace pctile=82 if income_pa>=dec81 & income_pa<dec82
replace pctile=83 if income_pa>=dec82 & income_pa<dec83
replace pctile=84 if income_pa>=dec83 & income_pa<dec84
replace pctile=85 if income_pa>=dec84 & income_pa<dec85
replace pctile=86 if income_pa>=dec85 & income_pa<dec86
replace pctile=87 if income_pa>=dec86 & income_pa<dec87
replace pctile=88 if income_pa>=dec87 & income_pa<dec88
replace pctile=89 if income_pa>=dec88 & income_pa<dec89
replace pctile=90 if income_pa>=dec89 & income_pa<dec90


replace pctile=91 if income_pa>=dec90 & income_pa<dec91
replace pctile=92 if income_pa>=dec91 & income_pa<dec92
replace pctile=93 if income_pa>=dec92 & income_pa<dec93
replace pctile=94 if income_pa>=dec93 & income_pa<dec94
replace pctile=95 if income_pa>=dec94 & income_pa<dec95
replace pctile=96 if income_pa>=dec95 & income_pa<dec96
replace pctile=97 if income_pa>=dec96 & income_pa<dec97
replace pctile=98 if income_pa>=dec97 & income_pa<dec98
replace pctile=99 if income_pa>=dec98 & income_pa<dec99
replace pctile=100 if income_pa>=dec99 



save "$Out\reg_data_ushape.dta", replace

use "panel.dta",clear

drop if income_pa<6000
drop if income_pa==.
*winsor income_pa
winsor income_pa, g(xx) p(0.01)
replace income_pa=xx
drop xx

****************************************************************************
*****************************************************************************

***generating percentiles**************************

*making original kind of deciles
egen dec1=pctile(income_pa), p(1)
egen dec2=pctile(income_pa), p(2)
egen dec3=pctile(income_pa), p(3)
egen dec4=pctile(income_pa), p(4)
egen dec5=pctile(income_pa), p(5)
egen dec6=pctile(income_pa), p(6)
egen dec7=pctile(income_pa), p(7)
egen dec8=pctile(income_pa), p(8)
egen dec9=pctile(income_pa), p(9)

egen dec10=pctile(income_pa), p(10)
egen dec11=pctile(income_pa), p(11)
egen dec12=pctile(income_pa), p(12)
egen dec13=pctile(income_pa), p(13)
egen dec14=pctile(income_pa), p(14)
egen dec15=pctile(income_pa), p(15)
egen dec16=pctile(income_pa), p(16)
egen dec17=pctile(income_pa), p(17)
egen dec18=pctile(income_pa), p(18)
egen dec19=pctile(income_pa), p(19)

egen dec20=pctile(income_pa),  p(20)
egen dec21=pctile(income_pa),  p(21)
egen dec22=pctile(income_pa),  p(22)
egen dec23=pctile(income_pa),  p(23)
egen dec24=pctile(income_pa),  p(24)
egen dec25=pctile(income_pa),  p(25)
egen dec26=pctile(income_pa),  p(26)
egen dec27=pctile(income_pa),  p(27)
egen dec28=pctile(income_pa),  p(28)
egen dec29=pctile(income_pa),  p(29)

egen dec30=pctile(income_pa),  p(30)
egen dec31=pctile(income_pa),  p(31)
egen dec32=pctile(income_pa),  p(32)
egen dec33=pctile(income_pa),  p(33)
egen dec34=pctile(income_pa),  p(34)
egen dec35=pctile(income_pa),  p(35)
egen dec36=pctile(income_pa),  p(36)
egen dec37=pctile(income_pa),  p(37)
egen dec38=pctile(income_pa),  p(38)
egen dec39=pctile(income_pa),  p(39)

egen dec40=pctile(income_pa),  p(40)
egen dec41=pctile(income_pa),  p(41)
egen dec42=pctile(income_pa),  p(42)
egen dec43=pctile(income_pa),  p(43)
egen dec44=pctile(income_pa),  p(44)
egen dec45=pctile(income_pa),  p(45)
egen dec46=pctile(income_pa),  p(46)
egen dec47=pctile(income_pa),  p(47)
egen dec48=pctile(income_pa),  p(48)
egen dec49=pctile(income_pa),  p(49)

egen dec50=pctile(income_pa),  p(50)
egen dec51=pctile(income_pa),  p(51)
egen dec52=pctile(income_pa),  p(52)
egen dec53=pctile(income_pa),  p(53)
egen dec54=pctile(income_pa),  p(54)
egen dec55=pctile(income_pa),  p(55)
egen dec56=pctile(income_pa),  p(56)
egen dec57=pctile(income_pa),  p(57)
egen dec58=pctile(income_pa),  p(58)
egen dec59=pctile(income_pa),  p(59)

egen dec60=pctile(income_pa),  p(60)
egen dec61=pctile(income_pa),  p(61)
egen dec62=pctile(income_pa),  p(62)
egen dec63=pctile(income_pa),  p(63)
egen dec64=pctile(income_pa),  p(64)
egen dec65=pctile(income_pa),  p(65)
egen dec66=pctile(income_pa),  p(66)
egen dec67=pctile(income_pa),  p(67)
egen dec68=pctile(income_pa),  p(68)
egen dec69=pctile(income_pa),  p(69)

egen dec70=pctile(income_pa),  p(70)
egen dec71=pctile(income_pa),  p(71)
egen dec72=pctile(income_pa),  p(72)
egen dec73=pctile(income_pa),  p(73)
egen dec74=pctile(income_pa),  p(74)
egen dec75=pctile(income_pa),  p(75)
egen dec76=pctile(income_pa),  p(76)
egen dec77=pctile(income_pa),  p(77)
egen dec78=pctile(income_pa),  p(78)
egen dec79=pctile(income_pa),  p(79)

egen dec80=pctile(income_pa),  p(80)
egen dec81=pctile(income_pa),  p(81)
egen dec82=pctile(income_pa),  p(82)
egen dec83=pctile(income_pa),  p(83)
egen dec84=pctile(income_pa),  p(84)
egen dec85=pctile(income_pa),  p(85)
egen dec86=pctile(income_pa),  p(86)
egen dec87=pctile(income_pa),  p(87)
egen dec88=pctile(income_pa),  p(88)
egen dec89=pctile(income_pa),  p(89)

egen dec90=pctile(income_pa),  p(90)
egen dec91=pctile(income_pa),  p(91)
egen dec92=pctile(income_pa),  p(92)
egen dec93=pctile(income_pa),  p(93)
egen dec94=pctile(income_pa),  p(94)
egen dec95=pctile(income_pa),  p(95)
egen dec96=pctile(income_pa),  p(96)
egen dec97=pctile(income_pa),  p(97)
egen dec98=pctile(income_pa),  p(98)
egen dec99=pctile(income_pa),  p(99)




gen pctile=0
replace pctile=1 if income_pa<dec1
replace pctile=2 if income_pa>=dec1 & income_pa<dec2
replace pctile=3 if income_pa>=dec2 & income_pa<dec3
replace pctile=4 if income_pa>=dec3 & income_pa<dec4
replace pctile=5 if income_pa>=dec4 & income_pa<dec5
replace pctile=6 if income_pa>=dec5 & income_pa<dec6
replace pctile=7 if income_pa>=dec6 & income_pa<dec7
replace pctile=8 if income_pa>=dec7 & income_pa<dec8
replace pctile=9 if income_pa>=dec8 & income_pa<dec9
replace pctile=10 if income_pa>=dec9 & income_pa<dec10

replace pctile=11 if income_pa>=dec10 & income_pa<dec11
replace pctile=12 if income_pa>=dec11 & income_pa<dec12
replace pctile=13 if income_pa>=dec12 & income_pa<dec13
replace pctile=14 if income_pa>=dec13 & income_pa<dec14
replace pctile=15 if income_pa>=dec14 & income_pa<dec15
replace pctile=16 if income_pa>=dec15 & income_pa<dec16
replace pctile=17 if income_pa>=dec16 & income_pa<dec17
replace pctile=18 if income_pa>=dec17 & income_pa<dec18
replace pctile=19 if income_pa>=dec18 & income_pa<dec19
replace pctile=20 if income_pa>=dec19 & income_pa<dec20

replace pctile=21 if income_pa>=dec20 & income_pa<dec22
replace pctile=22 if income_pa>=dec21 & income_pa<dec22
replace pctile=23 if income_pa>=dec22 & income_pa<dec23
replace pctile=24 if income_pa>=dec23 & income_pa<dec24
replace pctile=25 if income_pa>=dec24 & income_pa<dec25
replace pctile=26 if income_pa>=dec25 & income_pa<dec26
replace pctile=27 if income_pa>=dec26 & income_pa<dec27
replace pctile=28 if income_pa>=dec27 & income_pa<dec28
replace pctile=29 if income_pa>=dec28 & income_pa<dec29
replace pctile=30 if income_pa>=dec29 & income_pa<dec30


replace pctile=31 if income_pa>=dec30 & income_pa<dec31
replace pctile=32 if income_pa>=dec31 & income_pa<dec32
replace pctile=33 if income_pa>=dec32 & income_pa<dec33
replace pctile=34 if income_pa>=dec33 & income_pa<dec34
replace pctile=35 if income_pa>=dec34 & income_pa<dec35
replace pctile=36 if income_pa>=dec35 & income_pa<dec36
replace pctile=37 if income_pa>=dec36 & income_pa<dec37
replace pctile=38 if income_pa>=dec37 & income_pa<dec38
replace pctile=39 if income_pa>=dec38 & income_pa<dec39
replace pctile=40 if income_pa>=dec39 & income_pa<dec40


replace pctile=41 if income_pa>=dec40 & income_pa<dec41
replace pctile=42 if income_pa>=dec41 & income_pa<dec42
replace pctile=43 if income_pa>=dec42 & income_pa<dec43
replace pctile=44 if income_pa>=dec43 & income_pa<dec44
replace pctile=45 if income_pa>=dec44 & income_pa<dec45
replace pctile=46 if income_pa>=dec45 & income_pa<dec46
replace pctile=47 if income_pa>=dec46 & income_pa<dec47
replace pctile=48 if income_pa>=dec47 & income_pa<dec48
replace pctile=49 if income_pa>=dec48 & income_pa<dec49
replace pctile=50 if income_pa>=dec49 & income_pa<dec50


replace pctile=51 if income_pa>=dec50 & income_pa<dec51
replace pctile=52 if income_pa>=dec51 & income_pa<dec52
replace pctile=53 if income_pa>=dec52 & income_pa<dec53
replace pctile=54 if income_pa>=dec53 & income_pa<dec54
replace pctile=55 if income_pa>=dec54 & income_pa<dec55
replace pctile=56 if income_pa>=dec55 & income_pa<dec56
replace pctile=57 if income_pa>=dec56 & income_pa<dec57
replace pctile=58 if income_pa>=dec57 & income_pa<dec58
replace pctile=59 if income_pa>=dec58 & income_pa<dec59
replace pctile=60 if income_pa>=dec59 & income_pa<dec60

replace pctile=61 if income_pa>=dec60 & income_pa<dec61
replace pctile=62 if income_pa>=dec61 & income_pa<dec62
replace pctile=63 if income_pa>=dec62 & income_pa<dec63
replace pctile=64 if income_pa>=dec63 & income_pa<dec64
replace pctile=65 if income_pa>=dec64 & income_pa<dec65
replace pctile=66 if income_pa>=dec65 & income_pa<dec66
replace pctile=67 if income_pa>=dec66 & income_pa<dec67
replace pctile=68 if income_pa>=dec67 & income_pa<dec68
replace pctile=69 if income_pa>=dec68 & income_pa<dec69
replace pctile=70 if income_pa>=dec69 & income_pa<dec70


replace pctile=71 if income_pa>=dec70 & income_pa<dec71
replace pctile=72 if income_pa>=dec71 & income_pa<dec72
replace pctile=73 if income_pa>=dec72 & income_pa<dec73
replace pctile=74 if income_pa>=dec73 & income_pa<dec74
replace pctile=75 if income_pa>=dec74 & income_pa<dec75
replace pctile=76 if income_pa>=dec75 & income_pa<dec76
replace pctile=77 if income_pa>=dec76 & income_pa<dec77
replace pctile=78 if income_pa>=dec77 & income_pa<dec78
replace pctile=79 if income_pa>=dec78 & income_pa<dec79
replace pctile=80 if income_pa>=dec79 & income_pa<dec80


replace pctile=81 if income_pa>=dec80 & income_pa<dec81
replace pctile=82 if income_pa>=dec81 & income_pa<dec82
replace pctile=83 if income_pa>=dec82 & income_pa<dec83
replace pctile=84 if income_pa>=dec83 & income_pa<dec84
replace pctile=85 if income_pa>=dec84 & income_pa<dec85
replace pctile=86 if income_pa>=dec85 & income_pa<dec86
replace pctile=87 if income_pa>=dec86 & income_pa<dec87
replace pctile=88 if income_pa>=dec87 & income_pa<dec88
replace pctile=89 if income_pa>=dec88 & income_pa<dec89
replace pctile=90 if income_pa>=dec89 & income_pa<dec90


replace pctile=91 if income_pa>=dec90 & income_pa<dec91
replace pctile=92 if income_pa>=dec91 & income_pa<dec92
replace pctile=93 if income_pa>=dec92 & income_pa<dec93
replace pctile=94 if income_pa>=dec93 & income_pa<dec94
replace pctile=95 if income_pa>=dec94 & income_pa<dec95
replace pctile=96 if income_pa>=dec95 & income_pa<dec96
replace pctile=97 if income_pa>=dec96 & income_pa<dec97
replace pctile=98 if income_pa>=dec97 & income_pa<dec98
replace pctile=99 if income_pa>=dec98 & income_pa<dec99
replace pctile=100 if income_pa>=dec99 

save "$Out\panel_with_pctile.dta", replace


*create cohort data
foreach num of numlist 1/12{
	use "reg_data_ushape.dta",clear
	drop if loginc_perm==.
	drop if loginc_perm_pa==.
	keep if birth_year>=`num'+1976 & birth_year<=`num'+1985
	save "reg_data_cohort_`num'.dta",replace
}








*drop if occu==. |occu==-1|occu==-2|occu==-7|occu==-8|occu==-9|occu==999999
*drop if edu==-9
*drop if eduy==-9

*winsor income_pa
*winsor income_pa, g(xx) p(0.01)
*replace income_pa=xx
*drop xx

*drop survey_year
*drop if prov==-9| county==-9| urban==-9
