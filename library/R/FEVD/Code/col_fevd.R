col_1   <- fevds[[3]]
col_2   <- fevds[[7]]
col_3   <- fevds[[11]]

pcom_col1 <- col_1[,c(1,14:19)]

wgdp_col2 <- col_2[,c(1,16:22)]
pcom_col2 <- col_2[,c(1,23:29)]

wgdp_col3 <- col_3[,c(1,18:25)]
vix_col3  <- col_3[,c(1,26:33)]
pcom_col3 <- col_3[,c(1,34:41)]

colnames(pcom_col1) <- c("Horizon","GDP","CPI","PCOM","CR","EXR","INTR")

colnames(wgdp_col2) <- c("Horizon","GDP","CPI","WGDP","PCOM","CR","EXR","INTR")
colnames(pcom_col2) <- c("Horizon","GDP","CPI","WGDP","PCOM","CR","EXR","INTR")

colnames(wgdp_col3) <- c("Horizon","GDP","CPI","WGDP","VIX","PCOM","CR","EXR","INTR")
colnames(vix_col3) <- c("Horizon","GDP","CPI","WGDP","VIX","PCOM","CR","EXR","INTR")
colnames(pcom_col3) <- c("Horizon","GDP","CPI","WGDP","VIX","PCOM","CR","EXR","INTR")

col_pcom1 <- gather(pcom_col1, key = Variable, value = Response, GDP, CPI, PCOM, CR, EXR, INTR)
Shock <- rep("PCOM", nrow(col_pcom1))
Country <- rep("Colombia", nrow(col_pcom1))
col_pcom1 <- cbind(col_pcom1, Shock, Country)

col_wgdp2 <- gather(wgdp_col2, key = Variable, value = Response, GDP, CPI, WGDP, PCOM, CR, EXR, INTR)
Shock <- rep("WGDP", nrow(col_wgdp2))
Country <- rep("Colombia", nrow(col_wgdp2))
col_wgdp2 <- cbind(col_wgdp2, Shock, Country)

col_pcom2 <- gather(pcom_col2, key = Variable, value = Response, GDP, CPI, WGDP, PCOM, CR, EXR, INTR)
Shock <- rep("PCOM", nrow(col_pcom2))
Country <- rep("Colombia", nrow(col_pcom2))
col_pcom2 <- cbind(col_pcom2, Shock, Country)

col_wgdp3 <- gather(wgdp_col3, key = Variable, value = Response, GDP, CPI, WGDP, VIX, PCOM, CR, EXR, INTR)
Shock <- rep("WGDP", nrow(col_wgdp3))
Country <- rep("Colombia", nrow(col_wgdp3))
col_wgdp3 <- cbind(col_wgdp3, Shock, Country)

col_vix3 <- gather(vix_col3, key = Variable, value = Response, GDP, CPI, WGDP, VIX, PCOM, CR, EXR, INTR)
Shock <- rep("VIX", nrow(col_vix3))
Country <- rep("Colombia", nrow(col_vix3))
col_vix3 <- cbind(col_vix3, Shock, Country)

col_pcom3 <- gather(pcom_col3, key = Variable, value = Response, GDP, CPI, WGDP, VIX, PCOM, CR, EXR, INTR)
Shock <- rep("PCOM", nrow(col_pcom3))
Country <- rep("Colombia", nrow(col_pcom3))
col_pcom3 <- cbind(col_pcom3, Shock, Country)

Model <- rep("M1", nrow(col_pcom1))
col_m1 <- cbind(col_pcom1, Model)

col_m2 <- bind_rows(col_wgdp2, col_pcom2)
Model <- rep("M2", nrow(col_m2))
col_m2 <- cbind(col_m2, Model)

col_m3 <- bind_rows(col_wgdp3, col_vix3, col_pcom3)
Model <- rep("M3", nrow(col_m3))
col_m3 <- cbind(col_m3, Model)

col_tidy <- bind_rows(col_m1,col_m2,col_m3)
col_tidy$Model <- factor(col_tidy$Model, levels = c("M1", "M2", "M3"), ordered = FALSE)