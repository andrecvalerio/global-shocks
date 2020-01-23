per_1   <- fevds[[4]]
per_2   <- fevds[[8]]
per_3   <- fevds[[12]]

pcom_per1 <- per_1[,c(1,14:19)]

wgdp_per2 <- per_2[,c(1,16:22)]
pcom_per2 <- per_2[,c(1,23:29)]

wgdp_per3 <- per_3[,c(1,18:25)]
vix_per3  <- per_3[,c(1,26:33)]
pcom_per3 <- per_3[,c(1,34:41)]

colnames(pcom_per1) <- c("Horizon","GDP","CPI","PCOM","CR","EXR","INTR")

colnames(wgdp_per2) <- c("Horizon","GDP","CPI","WGDP","PCOM","CR","EXR","INTR")
colnames(pcom_per2) <- c("Horizon","GDP","CPI","WGDP","PCOM","CR","EXR","INTR")

colnames(wgdp_per3) <- c("Horizon","GDP","CPI","WGDP","VIX","PCOM","CR","EXR","INTR")
colnames(vix_per3) <- c("Horizon","GDP","CPI","WGDP","VIX","PCOM","CR","EXR","INTR")
colnames(pcom_per3) <- c("Horizon","GDP","CPI","WGDP","VIX","PCOM","CR","EXR","INTR")

per_pcom1 <- gather(pcom_per1, key = Variable, value = Response, GDP, CPI, PCOM, CR, EXR, INTR)
Shock <- rep("PCOM", nrow(per_pcom1))
Country <- rep("Peru", nrow(per_pcom1))
per_pcom1 <- cbind(per_pcom1, Shock, Country)

per_wgdp2 <- gather(wgdp_per2, key = Variable, value = Response, GDP, CPI, WGDP, PCOM, CR, EXR, INTR)
Shock <- rep("WGDP", nrow(per_wgdp2))
Country <- rep("Peru", nrow(per_wgdp2))
per_wgdp2 <- cbind(per_wgdp2, Shock, Country)

per_pcom2 <- gather(pcom_per2, key = Variable, value = Response, GDP, CPI, WGDP, PCOM, CR, EXR, INTR)
Shock <- rep("PCOM", nrow(per_pcom2))
Country <- rep("Peru", nrow(per_pcom2))
per_pcom2 <- cbind(per_pcom2, Shock, Country)

per_wgdp3 <- gather(wgdp_per3, key = Variable, value = Response, GDP, CPI, WGDP, VIX, PCOM, CR, EXR, INTR)
Shock <- rep("WGDP", nrow(per_wgdp3))
Country <- rep("Peru", nrow(per_wgdp3))
per_wgdp3 <- cbind(per_wgdp3, Shock, Country)

per_vix3 <- gather(vix_per3, key = Variable, value = Response, GDP, CPI, WGDP, VIX, PCOM, CR, EXR, INTR)
Shock <- rep("VIX", nrow(per_vix3))
Country <- rep("Peru", nrow(per_vix3))
per_vix3 <- cbind(per_vix3, Shock, Country)

per_pcom3 <- gather(pcom_per3, key = Variable, value = Response, GDP, CPI, WGDP, VIX, PCOM, CR, EXR, INTR)
Shock <- rep("PCOM", nrow(per_pcom3))
Country <- rep("Peru", nrow(per_pcom3))
per_pcom3 <- cbind(per_pcom3, Shock, Country)

Model <- rep("M1", nrow(per_pcom1))
per_m1 <- cbind(per_pcom1, Model)

per_m2 <- bind_rows(per_wgdp2, per_pcom2)
Model <- rep("M2", nrow(per_m2))
per_m2 <- cbind(per_m2, Model)

per_m3 <- bind_rows(per_wgdp3, per_vix3, per_pcom3)
Model <- rep("M3", nrow(per_m3))
per_m3 <- cbind(per_m3, Model)

per_tidy <- bind_rows(per_m1,per_m2,per_m3)
per_tidy$Model <- factor(per_tidy$Model, levels = c("M1", "M2", "M3"), ordered = FALSE)