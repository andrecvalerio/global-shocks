ch_1   <- fevds[[2]]
ch_2   <- fevds[[6]]
ch_3   <- fevds[[10]]

pcom_ch1 <- ch_1[,c(1,14:19)]

wgdp_ch2 <- ch_2[,c(1,16:22)]
pcom_ch2 <- ch_2[,c(1,23:29)]

wgdp_ch3 <- ch_3[,c(1,18:25)]
vix_ch3  <- ch_3[,c(1,26:33)]
pcom_ch3 <- ch_3[,c(1,34:41)]

colnames(pcom_ch1) <- c("Horizon","GDP","CPI","PCOM","CR","EXR","INTR")

colnames(wgdp_ch2) <- c("Horizon","GDP","CPI","WGDP","PCOM","CR","EXR","INTR")
colnames(pcom_ch2) <- c("Horizon","GDP","CPI","WGDP","PCOM","CR","EXR","INTR")

colnames(wgdp_ch3) <- c("Horizon","GDP","CPI","WGDP","VIX","PCOM","CR","EXR","INTR")
colnames(vix_ch3) <- c("Horizon","GDP","CPI","WGDP","VIX","PCOM","CR","EXR","INTR")
colnames(pcom_ch3) <- c("Horizon","GDP","CPI","WGDP","VIX","PCOM","CR","EXR","INTR")

ch_pcom1 <- gather(pcom_ch1, key = Variable, value = Response, GDP, CPI, PCOM, CR, EXR, INTR)
Shock <- rep("PCOM", nrow(ch_pcom1))
Country <- rep("Chile", nrow(ch_pcom1))
ch_pcom1 <- cbind(ch_pcom1, Shock, Country)

ch_wgdp2 <- gather(wgdp_ch2, key = Variable, value = Response, GDP, CPI, WGDP, PCOM, CR, EXR, INTR)
Shock <- rep("WGDP", nrow(ch_wgdp2))
Country <- rep("Chile", nrow(ch_wgdp2))
ch_wgdp2 <- cbind(ch_wgdp2, Shock, Country)

ch_pcom2 <- gather(pcom_ch2, key = Variable, value = Response, GDP, CPI, WGDP, PCOM, CR, EXR, INTR)
Shock <- rep("PCOM", nrow(ch_pcom2))
Country <- rep("Chile", nrow(ch_pcom2))
ch_pcom2 <- cbind(ch_pcom2, Shock, Country)

ch_wgdp3 <- gather(wgdp_ch3, key = Variable, value = Response, GDP, CPI, WGDP, VIX, PCOM, CR, EXR, INTR)
Shock <- rep("WGDP", nrow(ch_wgdp3))
Country <- rep("Chile", nrow(ch_wgdp3))
ch_wgdp3 <- cbind(ch_wgdp3, Shock, Country)

ch_vix3 <- gather(vix_ch3, key = Variable, value = Response, GDP, CPI, WGDP, VIX, PCOM, CR, EXR, INTR)
Shock <- rep("VIX", nrow(ch_vix3))
Country <- rep("Chile", nrow(ch_vix3))
ch_vix3 <- cbind(ch_vix3, Shock, Country)

ch_pcom3 <- gather(pcom_ch3, key = Variable, value = Response, GDP, CPI, WGDP, VIX, PCOM, CR, EXR, INTR)
Shock <- rep("PCOM", nrow(ch_pcom3))
Country <- rep("Chile", nrow(ch_pcom3))
ch_pcom3 <- cbind(ch_pcom3, Shock, Country)

Model <- rep("M1", nrow(ch_pcom1))
ch_m1 <- cbind(ch_pcom1, Model)

ch_m2 <- bind_rows(ch_wgdp2, ch_pcom2)
Model <- rep("M2", nrow(ch_m2))
ch_m2 <- cbind(ch_m2, Model)

ch_m3 <- bind_rows(ch_wgdp3, ch_vix3, ch_pcom3)
Model <- rep("M3", nrow(ch_m3))
ch_m3 <- cbind(ch_m3, Model)

ch_tidy <- bind_rows(ch_m1,ch_m2,ch_m3)
ch_tidy$Model <- factor(ch_tidy$Model, levels = c("M1", "M2", "M3"), ordered = FALSE)

# gdp_br  <- filter(br_tidy, Variable  == "GDP" & Horizon == 4 | Horizon == 8 | Horizon == 16)
# cpi_br  <- filter(br_tidy, Variable  == "CPI" & Horizon == 4 | Horizon == 8 | Horizon == 16)
# cr_br   <- filter(br_tidy, Variable  == "CR" & Horizon == 4 | Horizon == 8 | Horizon == 16)
# exr_br  <- filter(br_tidy, Variable  == "EXR" & Horizon == 4 | Horizon == 8 | Horizon == 16)
# intr_br <- filter(br_tidy, Variable  == "INTR" & Horizon == 4 | Horizon == 8 | Horizon == 16)
# xticks  <- c(4,8,16)#seq(min(0), max(16), by = 1)
# 
# br_gdp <- ggplot(gdp_br, aes(Model, Response,fill = Shock)) +   
#        geom_bar(stat="identity", position = "stack") +
#        facet_grid(~ Horizon, scales = "free_x", space="free_x") +
#        theme(plot.title = element_text(size = 10, face = "bold", lineheight=1,hjust = 0), axis.text.x = element_text( size = rel(1.1), angle = 10),legend.position = "bottom",legend.title = element_blank()) + scale_y_continuous(labels = percent_format()) +
#        labs(x = "GDP",y="") + theme(axis.title.x=element_blank(),
#                               axis.title.y=element_blank()) +
#        scale_fill_manual("",values=c("PCOM"='#64E162',"VIX"='#f9a65a',"WGDP"='#599ad3')) + theme_minimal() + ggtitle("Brazil") + theme(plot.title = element_text(hjust = 0.5))
# 
# 
# br_cpi <- ggplot(cpi_br, aes(Model, Response,fill = Shock)) +   
#   geom_bar(stat="identity", position = "stack") +
#   facet_grid(~ Horizon, scales = "free_x", space="free_x") +
#   theme(plot.title = element_text(size = 10, face = "bold", lineheight=1,hjust = 0), axis.text.x = element_text( size = rel(1.1), angle = 10),legend.position = "bottom",legend.title = element_blank()) + scale_y_continuous(labels = percent_format()) +
#   labs(x = "CPI",y="") + theme(axis.title.x=element_blank(),
#                             axis.title.y=element_blank()) +
#   scale_fill_manual("",values=c("PCOM"='#64E162',"VIX"='#f9a65a',"WGDP"='#599ad3')) + theme_minimal()
# 
# br_cr <- ggplot(cr_br, aes(Model, Response,fill = Shock)) +   
#   geom_bar(stat="identity", position = "stack") +
#   facet_grid(~ Horizon, scales = "free_x", space="free_x") +
#   theme(plot.title = element_text(size = 10, face = "bold", lineheight=1,hjust = 0), axis.text.x = element_text( size = rel(1.1), angle = 10),legend.position = "bottom",legend.title = element_blank()) + scale_y_continuous(labels = percent_format()) +
#   labs(x = "CR",y="") + theme(axis.title.x=element_blank(),
#                             axis.title.y=element_blank()) +
#   scale_fill_manual("",values=c("PCOM"='#64E162',"VIX"='#f9a65a',"WGDP"='#599ad3')) + theme_minimal()
# 
# br_exr <- ggplot(exr_br, aes(Model, Response,fill = Shock)) +   
#   geom_bar(stat="identity", position = "stack") +
#   facet_grid(~ Horizon, scales = "free_x", space="free_x") +
#   theme(plot.title = element_text(size = 10, face = "bold", lineheight=1,hjust = 0), axis.text.x = element_text( size = rel(1.1), angle = 10),legend.position = "bottom",legend.title = element_blank()) + scale_y_continuous(labels = percent_format()) +
#   labs(x = "EXR",y="") + theme(axis.title.x=element_blank(),
#                             axis.title.y=element_blank()) +
#   scale_fill_manual("",values=c("PCOM"='#64E162',"VIX"='#f9a65a',"WGDP"='#599ad3')) + theme_minimal() + ggtitle("Brazil") + theme(plot.title = element_text(hjust = 0.5))
# 
# br_intr <- ggplot(intr_br, aes(Model, Response,fill = Shock)) +   
#   geom_bar(stat="identity", position = "stack") +
#   facet_grid(~ Horizon, scales = "free_x", space="free_x") +
#   theme(plot.title = element_text(size = 10, face = "bold", lineheight=1,hjust = 0), axis.text.x = element_text( size = rel(1.1), angle = 10),legend.position = "bottom",legend.title = element_blank()) + scale_y_continuous(labels = percent_format()) +
#   labs(x = "INTR",y="") + theme(axis.title.x=element_blank(),
#                             axis.title.y=element_blank()) +
#   scale_fill_manual("",values=c("PCOM"='#64E162',"VIX"='#f9a65a',"WGDP"='#599ad3')) + theme_minimal()

#x <- c(br_gdp,br_cpi,br_cr,br_exr,br_intr)
#rm(list=setdiff(ls(), "x")) 

#fevd1 <- grid.arrange(gdp,cpi,cr,exr,intr, nrow=5,ncol=1)
#fevd2 <- grid.arrange(exr,intr, nrow=2,ncol=1)

#ggsave("br_fevd.pdf", plot = fevd1, width = 40, height = 20, units = "cm")
#ggsave("br_fevd2.pdf", plot = fevd2, width = 40, height = 20, units = "cm")


