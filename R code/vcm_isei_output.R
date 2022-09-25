rm(list = ls())
setwd("C:/Users/huhu/Desktop/R_vcm")
######################################################################
sink("Full_A1.txt", append = F)
######################################################################
load("yxz_dat.Rda")
load("lm_model.Rda")
#load("teststat_pval.Rda")

load("gammas.Rda")
load("coef_mat_boot_1.Rda")
load("coef_mat_boot_2.Rda")
load("coef_mat_boot_3.Rda")
load("coef_mat_boot_4.Rda")
load("coef_mat_boot_5.Rda")
load("coef_mat_boot_6.Rda")
load("coef_mat_boot_7.Rda")
load("coef_mat_boot_8.Rda")
load("coef_mat_boot_9.Rda")
load("coef_mat_boot_10.Rda")
load("coef_mat_boot_11.Rda")

load("coef_mat_boot_avg.Rda")

load("mgamma_q.Rda")
load("mgamma_q_boot_1.Rda")
load("mgamma_q_boot_2.Rda")
load("mgamma_q_boot_3.Rda")
load("mgamma_q_boot_4.Rda")
load("mgamma_q_boot_5.Rda")
load("mgamma_q_boot_6.Rda")
load("mgamma_q_boot_7.Rda")
load("mgamma_q_boot_8.Rda")
load("mgamma_q_boot_9.Rda")
load("mgamma_q_boot_10.Rda")
load("mgamma_q_boot_11.Rda")

load("d1_2_boot.Rda")
load("d1_3_boot.Rda")
load("d1_4_boot.Rda")
load("d1_5_boot.Rda")
load("d2_3_boot.Rda")
load("d2_4_boot.Rda")
load("d2_5_boot.Rda")
load("d3_4_boot.Rda")
load("d3_5_boot.Rda")
load("d4_5_boot.Rda")

load("d1_2.Rda")
load("d1_3.Rda")
load("d1_4.Rda")
load("d1_5.Rda")
load("d2_3.Rda")
load("d2_4.Rda")
load("d2_5.Rda")
load("d3_4.Rda")
load("d3_5.Rda")
load("d4_5.Rda")
############################################################
# Testing for differences in means of the quintiles groups
probs <- c(0.05, 0.95)
probsA <- c(0.95, 0.05)

d1_2_boot_ci90<-t(apply(d1_2_boot,1,quantile,probs = probs))
d1_3_boot_ci90<-t(apply(d1_3_boot,1,quantile,probs = probs))
d1_4_boot_ci90<-t(apply(d1_4_boot,1,quantile,probs = probs))
d1_5_boot_ci90<-t(apply(d1_5_boot,1,quantile,probs = probs))
d2_3_boot_ci90<-t(apply(d2_3_boot,1,quantile,probs = probs))
d2_4_boot_ci90<-t(apply(d2_4_boot,1,quantile,probs = probs))
d2_5_boot_ci90<-t(apply(d2_5_boot,1,quantile,probs = probs))
d3_4_boot_ci90<-t(apply(d3_4_boot,1,quantile,probs = probs))
d3_5_boot_ci90<-t(apply(d3_5_boot,1,quantile,probs = probs))
d4_5_boot_ci90<-t(apply(d4_5_boot,1,quantile,probs = probs))

d1_2_boot_ciA90<-d1_2-t(apply((d1_2_boot-d1_2),1,quantile,probs = probsA))
d1_3_boot_ciA90<-d1_3-t(apply((d1_3_boot-d1_3),1,quantile,probs = probsA))
d1_4_boot_ciA90<-d1_4-t(apply((d1_4_boot-d1_4),1,quantile,probs = probsA))
d1_5_boot_ciA90<-d1_5-t(apply((d1_5_boot-d1_5),1,quantile,probs = probsA))
d2_3_boot_ciA90<-d2_3-t(apply((d2_3_boot-d2_3),1,quantile,probs = probsA))
d2_4_boot_ciA90<-d2_4-t(apply((d2_4_boot-d2_4),1,quantile,probs = probsA))
d2_5_boot_ciA90<-d2_5-t(apply((d2_5_boot-d2_5),1,quantile,probs = probsA))
d3_4_boot_ciA90<-d3_4-t(apply((d3_4_boot-d3_4),1,quantile,probs = probsA))
d3_5_boot_ciA90<-d3_5-t(apply((d3_5_boot-d3_5),1,quantile,probs = probsA))
d4_5_boot_ciA90<-d4_5-t(apply((d4_5_boot-d4_5),1,quantile,probs = probsA))

print("90% CI of differences in means of the quintiles groups")
print(round(d1_2_boot_ci90,3))
print(round(d1_3_boot_ci90,3))
print(round(d1_4_boot_ci90,3))
print(round(d1_5_boot_ci90,3))
print(round(d2_3_boot_ci90,3))
print(round(d2_4_boot_ci90,3))
print(round(d2_5_boot_ci90,3))
print(round(d3_4_boot_ci90,3))
print(round(d3_5_boot_ci90,3))
print(round(d4_5_boot_ci90,3)) 

print("90% CIA of differences in means of the quintiles groups")
print(round(d1_2_boot_ciA90,3))
print(round(d1_3_boot_ciA90,3))
print(round(d1_4_boot_ciA90,3))
print(round(d1_5_boot_ciA90,3))
print(round(d2_3_boot_ciA90,3))
print(round(d2_4_boot_ciA90,3))
print(round(d2_5_boot_ciA90,3))
print(round(d3_4_boot_ciA90,3))
print(round(d3_5_boot_ciA90,3))
print(round(d4_5_boot_ciA90,3))

IGE_diff_means_q_ci90A <- rbind(
cbind(d1_2[2],t(d1_2_boot_ciA90[2,])),
cbind(d1_3[2],t(d1_3_boot_ciA90[2,])),
cbind(d1_4[2],t(d1_4_boot_ciA90[2,])),
cbind(d1_5[2],t(d1_5_boot_ciA90[2,])),
cbind(d2_3[2],t(d2_3_boot_ciA90[2,])),
cbind(d2_4[2],t(d2_4_boot_ciA90[2,])),
cbind(d2_5[2],t(d2_5_boot_ciA90[2,])),
cbind(d3_4[2],t(d3_4_boot_ciA90[2,])),
cbind(d3_5[2],t(d3_5_boot_ciA90[2,])),
cbind(d4_5[2],t(d4_5_boot_ciA90[2,])))
write.csv(IGE_diff_means_q_ci90A,"Full_A1_IGE_diff_means_q_ci90A.csv")

stest90 <-matrix(NaN,11,10)
stest90[,1] <-1-(d1_2_boot_ci90[,1]<0 & d1_2_boot_ci90[,2]>0)*1
stest90[,2] <-1-(d1_3_boot_ci90[,1]<0 & d1_3_boot_ci90[,2]>0)*1
stest90[,3] <-1-(d1_4_boot_ci90[,1]<0 & d1_4_boot_ci90[,2]>0)*1
stest90[,4] <-1-(d1_5_boot_ci90[,1]<0 & d1_5_boot_ci90[,2]>0)*1
stest90[,5] <-1-(d2_3_boot_ci90[,1]<0 & d2_3_boot_ci90[,2]>0)*1
stest90[,6] <-1-(d2_4_boot_ci90[,1]<0 & d2_4_boot_ci90[,2]>0)*1
stest90[,7] <-1-(d2_5_boot_ci90[,1]<0 & d2_5_boot_ci90[,2]>0)*1
stest90[,8] <-1-(d3_4_boot_ci90[,1]<0 & d3_4_boot_ci90[,2]>0)*1
stest90[,9] <-1-(d3_5_boot_ci90[,1]<0 & d3_5_boot_ci90[,2]>0)*1
stest90[,10] <-1-(d4_5_boot_ci90[,1]<0 & d4_5_boot_ci90[,2]>0)*1
write.csv(stest90,"stest90.csv")

stest90A <-matrix(NaN,11,10)
stest90A[,1] <-1-(d1_2_boot_ciA90[,1]<0 & d1_2_boot_ciA90[,2]>0)*1
stest90A[,2] <-1-(d1_3_boot_ciA90[,1]<0 & d1_3_boot_ciA90[,2]>0)*1
stest90A[,3] <-1-(d1_4_boot_ciA90[,1]<0 & d1_4_boot_ciA90[,2]>0)*1
stest90A[,4] <-1-(d1_5_boot_ciA90[,1]<0 & d1_5_boot_ciA90[,2]>0)*1
stest90A[,5] <-1-(d2_3_boot_ciA90[,1]<0 & d2_3_boot_ciA90[,2]>0)*1
stest90A[,6] <-1-(d2_4_boot_ciA90[,1]<0 & d2_4_boot_ciA90[,2]>0)*1
stest90A[,7] <-1-(d2_5_boot_ciA90[,1]<0 & d2_5_boot_ciA90[,2]>0)*1
stest90A[,8] <-1-(d3_4_boot_ciA90[,1]<0 & d3_4_boot_ciA90[,2]>0)*1
stest90A[,9] <-1-(d3_5_boot_ciA90[,1]<0 & d3_5_boot_ciA90[,2]>0)*1
stest90A[,10] <-1-(d4_5_boot_ciA90[,1]<0 & d4_5_boot_ciA90[,2]>0)*1
write.csv(stest90A,"stest90A.csv")


probs <- c(0.025, 0.975)
probsA <- c(0.975, 0.025)

d1_2_boot_ci95<-t(apply(d1_2_boot,1,quantile,probs = probs))
d1_3_boot_ci95<-t(apply(d1_3_boot,1,quantile,probs = probs))
d1_4_boot_ci95<-t(apply(d1_4_boot,1,quantile,probs = probs))
d1_5_boot_ci95<-t(apply(d1_5_boot,1,quantile,probs = probs))
d2_3_boot_ci95<-t(apply(d2_3_boot,1,quantile,probs = probs))
d2_4_boot_ci95<-t(apply(d2_4_boot,1,quantile,probs = probs))
d2_5_boot_ci95<-t(apply(d2_5_boot,1,quantile,probs = probs))
d3_4_boot_ci95<-t(apply(d3_4_boot,1,quantile,probs = probs))
d3_5_boot_ci95<-t(apply(d3_5_boot,1,quantile,probs = probs))
d4_5_boot_ci95<-t(apply(d4_5_boot,1,quantile,probs = probs))

d1_2_boot_ciA95<-d1_2-t(apply((d1_2_boot-d1_2),1,quantile,probs = probsA))
d1_3_boot_ciA95<-d1_3-t(apply((d1_3_boot-d1_3),1,quantile,probs = probsA))
d1_4_boot_ciA95<-d1_4-t(apply((d1_4_boot-d1_4),1,quantile,probs = probsA))
d1_5_boot_ciA95<-d1_5-t(apply((d1_5_boot-d1_5),1,quantile,probs = probsA))
d2_3_boot_ciA95<-d2_3-t(apply((d2_3_boot-d2_3),1,quantile,probs = probsA))
d2_4_boot_ciA95<-d2_4-t(apply((d2_4_boot-d2_4),1,quantile,probs = probsA))
d2_5_boot_ciA95<-d2_5-t(apply((d2_5_boot-d2_5),1,quantile,probs = probsA))
d3_4_boot_ciA95<-d3_4-t(apply((d3_4_boot-d3_4),1,quantile,probs = probsA))
d3_5_boot_ciA95<-d3_5-t(apply((d3_5_boot-d3_5),1,quantile,probs = probsA))
d4_5_boot_ciA95<-d4_5-t(apply((d4_5_boot-d4_5),1,quantile,probs = probsA))

print("95% CI of differences in means of the quintiles groups")
print(round(d1_2_boot_ci95,3))
print(round(d1_3_boot_ci95,3))
print(round(d1_4_boot_ci95,3))
print(round(d1_5_boot_ci95,3))
print(round(d2_3_boot_ci95,3))
print(round(d2_4_boot_ci95,3))
print(round(d2_5_boot_ci95,3))
print(round(d3_4_boot_ci95,3))
print(round(d3_5_boot_ci95,3))
print(round(d4_5_boot_ci95,3)) 

print("95% CIA of differences in means of the quintiles groups")
print(round(d1_2_boot_ciA95,3))
print(round(d1_3_boot_ciA95,3))
print(round(d1_4_boot_ciA95,3))
print(round(d1_5_boot_ciA95,3))
print(round(d2_3_boot_ciA95,3))
print(round(d2_4_boot_ciA95,3))
print(round(d2_5_boot_ciA95,3))
print(round(d3_4_boot_ciA95,3))
print(round(d3_5_boot_ciA95,3))
print(round(d4_5_boot_ciA95,3)) 


stest95 <-matrix(NaN,11,10)
stest95[,1] <-1-(d1_2_boot_ci95[,1]<0 & d1_2_boot_ci95[,2]>0)*1
stest95[,2] <-1-(d1_3_boot_ci95[,1]<0 & d1_3_boot_ci95[,2]>0)*1
stest95[,3] <-1-(d1_4_boot_ci95[,1]<0 & d1_4_boot_ci95[,2]>0)*1
stest95[,4] <-1-(d1_5_boot_ci95[,1]<0 & d1_5_boot_ci95[,2]>0)*1
stest95[,5] <-1-(d2_3_boot_ci95[,1]<0 & d2_3_boot_ci95[,2]>0)*1
stest95[,6] <-1-(d2_4_boot_ci95[,1]<0 & d2_4_boot_ci95[,2]>0)*1
stest95[,7] <-1-(d2_5_boot_ci95[,1]<0 & d2_5_boot_ci95[,2]>0)*1
stest95[,8] <-1-(d3_4_boot_ci95[,1]<0 & d3_4_boot_ci95[,2]>0)*1
stest95[,9] <-1-(d3_5_boot_ci95[,1]<0 & d3_5_boot_ci95[,2]>0)*1
stest95[,10] <-1-(d4_5_boot_ci95[,1]<0 & d4_5_boot_ci95[,2]>0)*1
write.csv(stest95,"stest95.csv")

stest95A <-matrix(NaN,11,10)
stest95A[,1] <-1-(d1_2_boot_ciA95[,1]<0 & d1_2_boot_ciA95[,2]>0)*1
stest95A[,2] <-1-(d1_3_boot_ciA95[,1]<0 & d1_3_boot_ciA95[,2]>0)*1
stest95A[,3] <-1-(d1_4_boot_ciA95[,1]<0 & d1_4_boot_ciA95[,2]>0)*1
stest95A[,4] <-1-(d1_5_boot_ciA95[,1]<0 & d1_5_boot_ciA95[,2]>0)*1
stest95A[,5] <-1-(d2_3_boot_ciA95[,1]<0 & d2_3_boot_ciA95[,2]>0)*1
stest95A[,6] <-1-(d2_4_boot_ciA95[,1]<0 & d2_4_boot_ciA95[,2]>0)*1
stest95A[,7] <-1-(d2_5_boot_ciA95[,1]<0 & d2_5_boot_ciA95[,2]>0)*1
stest95A[,8] <-1-(d3_4_boot_ciA95[,1]<0 & d3_4_boot_ciA95[,2]>0)*1
stest95A[,9] <-1-(d3_5_boot_ciA95[,1]<0 & d3_5_boot_ciA95[,2]>0)*1
stest95A[,10] <-1-(d4_5_boot_ciA95[,1]<0 & d4_5_boot_ciA95[,2]>0)*1
write.csv(stest95A,"stest95A.csv")

 
probs <- c(0.005, 0.995)
probsA <- c(0.995, 0.005)

d1_2_boot_ci99<-t(apply(d1_2_boot,1,quantile,probs = probs))
d1_3_boot_ci99<-t(apply(d1_3_boot,1,quantile,probs = probs))
d1_4_boot_ci99<-t(apply(d1_4_boot,1,quantile,probs = probs))
d1_5_boot_ci99<-t(apply(d1_5_boot,1,quantile,probs = probs))
d2_3_boot_ci99<-t(apply(d2_3_boot,1,quantile,probs = probs))
d2_4_boot_ci99<-t(apply(d2_4_boot,1,quantile,probs = probs))
d2_5_boot_ci99<-t(apply(d2_5_boot,1,quantile,probs = probs))
d3_4_boot_ci99<-t(apply(d3_4_boot,1,quantile,probs = probs))
d3_5_boot_ci99<-t(apply(d3_5_boot,1,quantile,probs = probs))
d4_5_boot_ci99<-t(apply(d4_5_boot,1,quantile,probs = probs))

d1_2_boot_ciA99<-d1_2-t(apply((d1_2_boot-d1_2),1,quantile,probs = probsA))
d1_3_boot_ciA99<-d1_3-t(apply((d1_3_boot-d1_3),1,quantile,probs = probsA))
d1_4_boot_ciA99<-d1_4-t(apply((d1_4_boot-d1_4),1,quantile,probs = probsA))
d1_5_boot_ciA99<-d1_5-t(apply((d1_5_boot-d1_5),1,quantile,probs = probsA))
d2_3_boot_ciA99<-d2_3-t(apply((d2_3_boot-d2_3),1,quantile,probs = probsA))
d2_4_boot_ciA99<-d2_4-t(apply((d2_4_boot-d2_4),1,quantile,probs = probsA))
d2_5_boot_ciA99<-d2_5-t(apply((d2_5_boot-d2_5),1,quantile,probs = probsA))
d3_4_boot_ciA99<-d3_4-t(apply((d3_4_boot-d3_4),1,quantile,probs = probsA))
d3_5_boot_ciA99<-d3_5-t(apply((d3_5_boot-d3_5),1,quantile,probs = probsA))
d4_5_boot_ciA99<-d4_5-t(apply((d4_5_boot-d4_5),1,quantile,probs = probsA))

print("99% CI of differences in means of the quintiles groups")
print(round(d1_2_boot_ci99,3))
print(round(d1_3_boot_ci99,3))
print(round(d1_4_boot_ci99,3))
print(round(d1_5_boot_ci99,3))
print(round(d2_3_boot_ci99,3))
print(round(d2_4_boot_ci99,3))
print(round(d2_5_boot_ci99,3))
print(round(d3_4_boot_ci99,3))
print(round(d3_5_boot_ci99,3))
print(round(d4_5_boot_ci99,3))

print("99% CIA of differences in means of the quintiles groups")
print(round(d1_2_boot_ciA99,3))
print(round(d1_3_boot_ciA99,3))
print(round(d1_4_boot_ciA99,3))
print(round(d1_5_boot_ciA99,3))
print(round(d2_3_boot_ciA99,3))
print(round(d2_4_boot_ciA99,3))
print(round(d2_5_boot_ciA99,3))
print(round(d3_4_boot_ciA99,3))
print(round(d3_5_boot_ciA99,3))
print(round(d4_5_boot_ciA99,3))

stest99 <-matrix(NaN,11,10)
stest99[,1] <-1-(d1_2_boot_ci99[,1]<0 & d1_2_boot_ci99[,2]>0)*1
stest99[,2] <-1-(d1_3_boot_ci99[,1]<0 & d1_3_boot_ci99[,2]>0)*1
stest99[,3] <-1-(d1_4_boot_ci99[,1]<0 & d1_4_boot_ci99[,2]>0)*1
stest99[,4] <-1-(d1_5_boot_ci99[,1]<0 & d1_5_boot_ci99[,2]>0)*1
stest99[,5] <-1-(d2_3_boot_ci99[,1]<0 & d2_3_boot_ci99[,2]>0)*1
stest99[,6] <-1-(d2_4_boot_ci99[,1]<0 & d2_4_boot_ci99[,2]>0)*1
stest99[,7] <-1-(d2_5_boot_ci99[,1]<0 & d2_5_boot_ci99[,2]>0)*1
stest99[,8] <-1-(d3_4_boot_ci99[,1]<0 & d3_4_boot_ci99[,2]>0)*1
stest99[,9] <-1-(d3_5_boot_ci99[,1]<0 & d3_5_boot_ci99[,2]>0)*1
stest99[,10] <-1-(d4_5_boot_ci99[,1]<0 & d4_5_boot_ci99[,2]>0)*1
write.csv(stest99,"stest99.csv")

stest99A <-matrix(NaN,11,10)
stest99A[,1] <-1-(d1_2_boot_ciA99[,1]<0 & d1_2_boot_ciA99[,2]>0)*1
stest99A[,2] <-1-(d1_3_boot_ciA99[,1]<0 & d1_3_boot_ciA99[,2]>0)*1
stest99A[,3] <-1-(d1_4_boot_ciA99[,1]<0 & d1_4_boot_ciA99[,2]>0)*1
stest99A[,4] <-1-(d1_5_boot_ciA99[,1]<0 & d1_5_boot_ciA99[,2]>0)*1
stest99A[,5] <-1-(d2_3_boot_ciA99[,1]<0 & d2_3_boot_ciA99[,2]>0)*1
stest99A[,6] <-1-(d2_4_boot_ciA99[,1]<0 & d2_4_boot_ciA99[,2]>0)*1
stest99A[,7] <-1-(d2_5_boot_ciA99[,1]<0 & d2_5_boot_ciA99[,2]>0)*1
stest99A[,8] <-1-(d3_4_boot_ciA99[,1]<0 & d3_4_boot_ciA99[,2]>0)*1
stest99A[,9] <-1-(d3_5_boot_ciA99[,1]<0 & d3_5_boot_ciA99[,2]>0)*1
stest99A[,10] <-1-(d4_5_boot_ciA99[,1]<0 & d4_5_boot_ciA99[,2]>0)*1
write.csv(stest99A,"stest99A.csv")

############################################################

# get z variable
z_dat <-yxz_dat$ypz
n <- length(z_dat)
# Get linear output
summary(lm_model)
lm_model_coef <- lm_model$coefficients

print("Bootstrap p-value for testing the null of linearity")
pval <- readRDS("C:/Users/huhu/Desktop/R_vcm/pval1.Rda")
print(pval)
## Compute standard deviations

boot_std_avg <-apply(coef_mat_boot_avg,1,sd)
boot_t_avg <-colMeans(gammas)/boot_std_avg
print("Average coef and their boot std errors")
rbind(round(colMeans(gammas),5),round(boot_std_avg,5),round(boot_t_avg,5))

boot_std_mgamma_q_1 <-apply(mgamma_q_boot_1,1,sd)
boot_std_mgamma_q_2 <-apply(mgamma_q_boot_2,1,sd)
boot_std_mgamma_q_3 <-apply(mgamma_q_boot_3,1,sd)
boot_std_mgamma_q_4 <-apply(mgamma_q_boot_4,1,sd)
boot_std_mgamma_q_5 <-apply(mgamma_q_boot_5,1,sd)
boot_std_mgamma_q_6 <-apply(mgamma_q_boot_6,1,sd)
boot_std_mgamma_q_7 <-apply(mgamma_q_boot_7,1,sd)
boot_std_mgamma_q_8 <-apply(mgamma_q_boot_8,1,sd)
boot_std_mgamma_q_9 <-apply(mgamma_q_boot_9,1,sd)
boot_std_mgamma_q_10 <-apply(mgamma_q_boot_10,1,sd)
boot_std_mgamma_q_11 <-apply(mgamma_q_boot_11,1,sd)
print("")
# printing average quintile coef and their boot std errors
print("Average coefficient of quintiles and their boot std errors")
print(cbind(round(mgamma_q[,1],5),round(boot_std_mgamma_q_1,5)))
print(cbind(round(mgamma_q[,2],5),round(boot_std_mgamma_q_2,5)))
print(cbind(round(mgamma_q[,3],5),round(boot_std_mgamma_q_3,5)))
print(cbind(round(mgamma_q[,4],5),round(boot_std_mgamma_q_4,5)))
print(cbind(round(mgamma_q[,5],5),round(boot_std_mgamma_q_5,5)))
print(cbind(round(mgamma_q[,6],5),round(boot_std_mgamma_q_6,5)))
print(cbind(round(mgamma_q[,7],5),round(boot_std_mgamma_q_7,5)))
print(cbind(round(mgamma_q[,8],5),round(boot_std_mgamma_q_8,5)))
print(cbind(round(mgamma_q[,9],5),round(boot_std_mgamma_q_9,5)))
print(cbind(round(mgamma_q[,10],5),round(boot_std_mgamma_q_10,5)))
print(cbind(round(mgamma_q[,11],5),round(boot_std_mgamma_q_11,5)))
# Obtain boot CI for the varying coefficients

probs <- c(0.05, 0.95)
probsA <- c(0.95, 0.05)

coef_mat_boot_1_ci<-t(apply(coef_mat_boot_1,1,quantile,probs = probs))
coef_mat_boot_2_ci<-t(apply(coef_mat_boot_2,1,quantile,probs = probs))
coef_mat_boot_3_ci<-t(apply(coef_mat_boot_3,1,quantile,probs = probs))
coef_mat_boot_4_ci<-t(apply(coef_mat_boot_4,1,quantile,probs = probs))
coef_mat_boot_5_ci<-t(apply(coef_mat_boot_5,1,quantile,probs = probs))
coef_mat_boot_6_ci<-t(apply(coef_mat_boot_6,1,quantile,probs = probs))
coef_mat_boot_7_ci<-t(apply(coef_mat_boot_7,1,quantile,probs = probs))
coef_mat_boot_8_ci<-t(apply(coef_mat_boot_8,1,quantile,probs = probs))
coef_mat_boot_9_ci<-t(apply(coef_mat_boot_9,1,quantile,probs = probs))
coef_mat_boot_10_ci<-t(apply(coef_mat_boot_10,1,quantile,probs = probs))
coef_mat_boot_11_ci<-t(apply(coef_mat_boot_11,1,quantile,probs = probs))

coef_mat_boot_1_ciA<- gammas[,1] - t(apply((coef_mat_boot_1 - gammas[,1]),1,quantile,probs = probsA))
coef_mat_boot_2_ciA<- gammas[,2] - t(apply((coef_mat_boot_2 - gammas[,2]),1,quantile,probs = probsA))
coef_mat_boot_3_ciA<- gammas[,3] - t(apply((coef_mat_boot_3 - gammas[,3]),1,quantile,probs = probsA))
coef_mat_boot_4_ciA<- gammas[,4] - t(apply((coef_mat_boot_4 - gammas[,4]),1,quantile,probs = probsA))
coef_mat_boot_5_ciA<- gammas[,5] - t(apply((coef_mat_boot_5 - gammas[,5]),1,quantile,probs = probsA))
coef_mat_boot_6_ciA<- gammas[,6] - t(apply((coef_mat_boot_6 - gammas[,6]),1,quantile,probs = probsA))
coef_mat_boot_7_ciA<- gammas[,6] - t(apply((coef_mat_boot_7 - gammas[,7]),1,quantile,probs = probsA))
coef_mat_boot_8_ciA<- gammas[,6] - t(apply((coef_mat_boot_8 - gammas[,8]),1,quantile,probs = probsA))
coef_mat_boot_9_ciA<- gammas[,6] - t(apply((coef_mat_boot_9 - gammas[,9]),1,quantile,probs = probsA))
coef_mat_boot_10_ciA<- gammas[,10] - t(apply((coef_mat_boot_10 - gammas[,10]),1,quantile,probs = probsA))
coef_mat_boot_11_ciA<- gammas[,11] - t(apply((coef_mat_boot_11 - gammas[,11]),1,quantile,probs = probsA))


################################################


trim_up <-0.01
trim_low <-0.01

dev.new()
setEPS()
postscript("panel_ci.eps")
temp <-trim_up
par(mfrow=c(6,2))
temp <-cbind(z_dat,rep(lm_model_coef[1],n),gammas[,1],coef_mat_boot_1_ci[,1],coef_mat_boot_1_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, ,col = c(3,1,2,2), xlab="Parents' Income", ylab="Intercept")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[2],n),gammas[,2],coef_mat_boot_2_ci[,1],coef_mat_boot_2_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="inc-isei")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[3],n),gammas[,3],coef_mat_boot_3_ci[,1],coef_mat_boot_3_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Child's Age")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[4],n),gammas[,4],coef_mat_boot_4_ci[,1],coef_mat_boot_4_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Child's Age^2")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[5],n),gammas[,5],coef_mat_boot_5_ci[,1],coef_mat_boot_5_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[6],n),gammas[,6],coef_mat_boot_6_ci[,1],coef_mat_boot_6_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age^2")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[7],n),gammas[,7],coef_mat_boot_7_ci[,1],coef_mat_boot_7_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age^2")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[8],n),gammas[,8],coef_mat_boot_8_ci[,1],coef_mat_boot_8_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age^2")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[9],n),gammas[,9],coef_mat_boot_9_ci[,1],coef_mat_boot_9_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age^2")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[10],n),gammas[,10],coef_mat_boot_10_ci[,1],coef_mat_boot_10_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age^2")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[11],n),gammas[,11],coef_mat_boot_11_ci[,1],coef_mat_boot_11_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age^2")
dev.off()

# plot IGM
dev.new()
setEPS()
postscript("IGM_ci.eps")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[2],n),gammas[,2],coef_mat_boot_2_ci[,1],coef_mat_boot_2_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="IGM")
dev.off()

# plot intercept
dev.new()
setEPS()
postscript("intercept_ci.eps")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[1],n),gammas[,1],coef_mat_boot_1_ci[,1],coef_mat_boot_1_ci[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Intercept")
dev.off()

# Using adjusted CI

# Using trimming
trim_up <-0.01
trim_low <-0.01

temp <-trim_up
dev.new()
setEPS()
postscript("panel_ciA.eps")
par(mfrow=c(5,2))
temp <-cbind(z_dat,rep(lm_model_coef[1],n),gammas[,1],coef_mat_boot_1_ciA[,1],coef_mat_boot_1_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, ,col = c(3,1,2,2), xlab="Parents' Income", ylab="Intercept")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[2],n),gammas[,2],coef_mat_boot_2_ciA[,1],coef_mat_boot_2_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="IGE")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[3],n),gammas[,3],coef_mat_boot_3_ciA[,1],coef_mat_boot_3_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Child's Age")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[4],n),gammas[,4],coef_mat_boot_4_ciA[,1],coef_mat_boot_4_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Child's Age^2")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[5],n),gammas[,5],coef_mat_boot_5_ciA[,1],coef_mat_boot_5_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[6],n),gammas[,6],coef_mat_boot_6_ciA[,1],coef_mat_boot_6_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age^2")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[7],n),gammas[,7],coef_mat_boot_7_ciA[,1],coef_mat_boot_7_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age^2")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[8],n),gammas[,8],coef_mat_boot_8_ciA[,1],coef_mat_boot_8_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age^2")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[9],n),gammas[,9],coef_mat_boot_9_ciA[,1],coef_mat_boot_9_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age^2")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[10],n),gammas[,10],coef_mat_boot_10_ciA[,1],coef_mat_boot_10_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age^2")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[11],n),gammas[,11],coef_mat_boot_11_ciA[,1],coef_mat_boot_11_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Mother's Age^2")
dev.off()

# plot IGM
dev.new()
setEPS()
postscript("IGM_ciA.eps")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[2],n),gammas[,2],coef_mat_boot_2_ciA[,1],coef_mat_boot_2_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="IGM")
dev.off()

# plot intercept
dev.new()
setEPS()
postscript("intercept_ciA.eps")
temp <-0
temp <-cbind(z_dat,rep(lm_model_coef[1],n),gammas[,1],coef_mat_boot_1_ciA[,1],coef_mat_boot_1_ciA[,2])
temp <- temp[order(temp[,1]),]
matplot(temp[floor(1+n*trim_low):floor(n-n*trim_up),1],temp[floor(1+n*trim_low):floor(n-n*trim_up),2:5],type="llll",lty=c(2,1,3,3),pch=1, col = c(3,1,2,2), xlab="Parents' Income", ylab="Intercept")
dev.off()
sink()