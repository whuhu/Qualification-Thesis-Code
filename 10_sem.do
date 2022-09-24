global path "C:\Users\huhu\Desktop\资格论文20220831\资格论文"
global D    "$path\data"      //数据文件
global Out  "$path\out"       //结果：图形和表格
cd "$D"                       //设定当前工作路径
set scheme s2color

use "$Out\reg_data_ushape.dta",clear

reg3 (eduy eduy_f eduy_m loginc_pa gender urban i.prov age ethnic)(loginc eduy logisei loginc_pa gender urban i.prov age ethnic)(logisei eduy logisei_f logisei_m loginc_pa gender urban i.prov age ethnic)

reg3 (eduy eduy_f eduy_m loginc_pa gender urban mid east age ethnic)(loginc eduy logisei loginc_pa gender urban mid east age ethnic)(logisei eduy logisei_f logisei_m loginc_pa gender urban mid east age ethnic)



sem (eduy<-eduy_f eduy_m loginc_pa gender urban mid east age ethnic)(loginc<-eduy logisei loginc_pa gender urban mid east age ethnic)(logisei<-eduy logisei_f logisei_m loginc_pa gender urban mid east age ethnic)