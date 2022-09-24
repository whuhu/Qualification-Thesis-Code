library(openxlsx)
library(plotly)
library(plot3D)

rm(list = ls())
setwd("C:/Users/haoliang/Desktop/资格论文/data")

dat <- read.xlsx("C:/Users/haoliang/Desktop/资格论文/data/3D_R.xlsx")


fig <- plot_ly(x = dat$loginc_pa, y = dat$eduy, z = dat$logisei, type = 'contour',colors = colorRamp(c("red", "green", "blue")))
fig


library(plotly)
# volcano is a numeric matrix that ships with R
fig <- plot_ly(z = ~volcano)
fig <- fig %>% add_surface()
fig

inc<-dat$loginc_pa
eduy<-dat$eduy
isei<-dat$logisei
plot_ly() %>% add_surface(data=dat,x = inc, y = eduy, z = isei)




scatter3D(dat$loginc_pa, dat$eduy, dat$logisei, pch = ".", cex = 3, colkey = FALSE)

surf3D(x = dat$loginc_pa, y = dat$eduy, z = dat$logisei, colkey=TRUE, bty="b2",
       phi = 40, theta = 30, main="Half of a Torus")


require(akima)
require(rgl)
x<-dat$loginc_pa
y<-dat$eduy
z<-dat$logisei

surface3d(x,y,z)



require(rgl)
require(reshape2)
dat.x<-unique(dat$loginc_pa)
dat.y<-unique(dat$eduy)
dat.z<-acast(dat,loginc_pa~logisei)
persp(dat.x,dat.y,dat.z)
surface3d(dat.x,dat.y,dat.z)


plot3d()
mesh3d(dat$loginc_pa, dat$eduy, dat$logisei,"parental income pctile","child eduy","child lnisei")


plot3d( 
  x=dat$loginc_pa, y=dat$eduy, dat$logisei, 
  col = , 
  type = 's', 
  radius = .1,
  xlab="Sepal Length", ylab="Sepal Width", zlab="Petal Length")

