##### FEVD Analysis
# Data manipulation -------------------------------------------------------

# Each routine generate a country-specific data frame
# Here I combine them together in a tidy format
df <- dplyr::bind_rows(br_tidy, 
                       ch_tidy,
                       col_tidy, 
                       per_tidy
)

# I factor the "horizon" and "variable" variables to be able to change the order in the panels and in the axis
df <- df %>% 
  dplyr::mutate(Variable = recode(Variable,
                                  "WGDP" = "World GDP",
                                  "PCOM" = "Commodity Prices",
                                  "VIX"  = "VIX"
  )
  ) %>% 
  dplyr::mutate(Shock = recode(Shock,
                               "WGDP" = "WDEM",
                               "PCOM" = "WSUP",
                               "VIX"  = "WUNC"
  )
  ) %>% 
  dplyr::mutate(Model = recode(Model,
                               "M1" = "Model 3",
                               "M2" = "Model 2", 
                               "M3" = "Model 1"
  )
  ) %>% 
  dplyr::mutate(Horizon = factor(Horizon,
                                 levels = c("1", 
                                            "2",
                                            "3",
                                            "4",
                                            "5",
                                            "6",
                                            "7",
                                            "8",
                                            "9",
                                            "10",
                                            "11",
                                            "12",
                                            "13",
                                            "14",
                                            "15",
                                            "16"
                                 ), 
                                 ordered = FALSE
  )
  ) %>% 
  dplyr::mutate(Variable = factor(Variable,
                                  levels = c("GDP",
                                             "CR",
                                             "EXR",
                                             "CPI",
                                             "INTR",
                                             "World GDP",
                                             "Commodity Prices",
                                             "VIX"
                                  )
  )
  ) %>% 
  dplyr::mutate(Model = factor(Model,
                               levels = c("Model 1", 
                                          "Model 2", 
                                          "Model 3"
                               )
  )
  ) 

# # I generate a bar plot for each model. M3 is the model with only WSUP in the international bloc
# # M2 is the model with WDEM and WSUP in the international bloc
# # M1 is the benchmark model
# df$Model <- dplyr::recode(df$Model, "M1" = "Model 3", "M2" = "Model 2", "M3" = "Model 1")
# df$Model <- factor(df$Model, levels = c("Model 1", "Model 2", "Model 3"))

# I only plot the FEVD of domestic variables to international shocks. 
# I selected 4 time points: 1 period after the shock and 4 and 16.


################## International bloc 

# Intl - WDEM --------------------------------------------------------------------
ndf <- df %>% 
  dplyr::filter(Model != "Model 3") 

wdem <- ndf %>% 
  dplyr::filter(Variable == "World GDP"
  ) %>% 
  dplyr::filter(Country == "Brazil") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Model",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = "World GDP"
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())


# Intl - WSUP -------------------------------------------------------------------

wsup <- ndf %>% 
  dplyr::filter(Variable == "Commodity Prices"
  ) %>% 
  dplyr::filter(Country == "Brazil") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Model",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = "Commodity Prices"
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        strip.text.x = element_blank(),
        axis.title.y.left = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())

# Intl - WUNC --------------------------------------------------------------------
wunc_ndf <- ndf %>% 
  dplyr::filter(Variable == "VIX" & 
                  Country == "Brazil"
  ) %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  )

wunc_ndf <- dplyr::add_row(wunc_ndf, 
                           Horizon = rep(c(1,4,16),
                                         3
                           ), 
                           Variable = rep("VIX",
                                          9
                           ), 
                           Response = rep(0,
                                          9
                           ),
                           Shock = c(rep("WDEM",
                                         3
                           ),
                           rep("WUNC",
                               3
                           ),
                           rep("WSUP",
                               3
                           )
                           ),
                           Country = rep("Brazil",
                                         9
                           ),
                           Model = rep("Model 2",
                                       9
                           )
)

wunc <- wunc_ndf %>% 
  dplyr::filter(Variable == "VIX"
  ) %>% 
  dplyr::filter(Country == "Brazil") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Model",
             scales = "fixed",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = "VIX"
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        strip.text.x = element_blank())




# Intl - Joining -----------------------------------------------------------------

intl <- ggpubr::ggarrange(wdem,
                          wsup,
                          wunc,
                          nrow = 3,
                          legend = "right",
                          common.legend = TRUE)

####### Model 1
# M1 - BR ----------------------------------------------------------------------

br <- df %>% 
  dplyr::filter(Variable == "GDP" | 
                  Variable == "CPI" | 
                  Variable == "CR" | 
                  Variable == "EXR" | 
                  Variable == "INTR"
  ) %>% 
  dplyr::filter(Country == "Brazil" & 
                  Model == "Model 1") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Variable",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = "Brazil"
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())


# M1 - Chile -------------------------------------------------------------------

ch <- df %>% 
  dplyr::filter(Variable == "GDP" | 
                  Variable == "CPI" | 
                  Variable == "CR" | 
                  Variable == "EXR" | 
                  Variable == "INTR"
  ) %>% 
  dplyr::filter(Country == "Chile" & 
                  Model == "Model 1") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Variable",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = "Chile"
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        strip.text.x = element_blank(),
        axis.title.y.left = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())

# M1 - Colombia ----------------------------------------------------------------

col <- df %>% 
  dplyr::filter(Variable == "GDP" | 
                  Variable == "CPI" | 
                  Variable == "CR" | 
                  Variable == "EXR" | 
                  Variable == "INTR"
  ) %>% 
  dplyr::filter(Country == "Colombia" & 
                  Model == "Model 1") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Variable",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = "Colombia"
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        strip.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())


# M1 - Peru --------------------------------------------------------------------

per <- df %>% 
  dplyr::filter(Variable == "GDP" | 
                  Variable == "CPI" | 
                  Variable == "CR" | 
                  Variable == "EXR" | 
                  Variable == "INTR"
  ) %>% 
  dplyr::filter(Country == "Peru" &
                  Model == "Model 1") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Variable",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = "Peru"
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        strip.text.x = element_blank())


# M1 Joining -----------------------------------------------------------------

m1 <- ggpubr::ggarrange(br,
                        ch,
                        col,
                        per,
                        nrow = 4,
                        legend = "right",
                        common.legend = TRUE)

###### Model 2
# M2 - BR ----------------------------------------------------------------------

br2 <- df %>% 
  dplyr::filter(Variable == "GDP" | 
                  Variable == "CPI" | 
                  Variable == "CR" | 
                  Variable == "EXR" | 
                  Variable == "INTR"
  ) %>% 
  dplyr::filter(Country == "Brazil" &
                 Model == "Model 2") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Variable",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = "Brazil"
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())


# M2 - Chile -------------------------------------------------------------------

ch2 <- df %>% 
  dplyr::filter(Variable == "GDP" | 
                  Variable == "CPI" | 
                  Variable == "CR" | 
                  Variable == "EXR" | 
                  Variable == "INTR"
  ) %>% 
  dplyr::filter(Country == "Chile" &
                  Model == "Model 2") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Variable",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = "Chile"
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        strip.text.x = element_blank(),
        axis.title.y.left = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())

# M2 - Colombia ----------------------------------------------------------------

col2 <- df %>% 
  dplyr::filter(Variable == "GDP" | 
                  Variable == "CPI" | 
                  Variable == "CR" | 
                  Variable == "EXR" | 
                  Variable == "INTR"
  ) %>% 
  dplyr::filter(Country == "Colombia" &
           Model == "Model 2") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Variable",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = "Colombia"
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        strip.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())


# M2 - Peru --------------------------------------------------------------------

per2 <- df %>% 
  dplyr::filter(Variable == "GDP" | 
                  Variable == "CPI" | 
                  Variable == "CR" | 
                  Variable == "EXR" | 
                  Variable == "INTR"
  ) %>% 
  dplyr::filter(Country == "Peru" &
           Model == "Model 2") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Variable",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = "Peru"
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        strip.text.x = element_blank())


# M2 - Joining -----------------------------------------------------------------

m2 <- ggpubr::ggarrange(br2,
                        ch2,
                        col2,
                        per2,
                        nrow = 4,
                        legend = "right",
                        common.legend = TRUE)

m2 <- ggpubr::annotate_figure(m2, 
                              top = text_grob("Model 2")
)


##### Model 3
# M3 - BR ----------------------------------------------------------------------

br3 <- df %>% 
  dplyr::filter(Variable == "GDP" | 
                  Variable == "CPI" | 
                  Variable == "CR" | 
                  Variable == "EXR" | 
                  Variable == "INTR"
  ) %>% 
  dplyr::filter(Country == "Brazil" &
                  Model == "Model 3") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
  ) +
  facet_wrap("Variable",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = ""
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())


# M3 - Chile -------------------------------------------------------------------

ch3 <- df %>% 
  dplyr::filter(Variable == "GDP" | 
                  Variable == "CPI" | 
                  Variable == "CR" | 
                  Variable == "EXR" | 
                  Variable == "INTR"
  ) %>% 
  dplyr::filter(Country == "Chile" &
                  Model == "Model 3") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Variable",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = ""
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        strip.text.x = element_blank(),
        axis.title.y.left = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())

# M3 - Colombia ----------------------------------------------------------------

col3 <- df %>% 
  dplyr::filter(Variable == "GDP" | 
                  Variable == "CPI" | 
                  Variable == "CR" | 
                  Variable == "EXR" | 
                  Variable == "INTR"
  ) %>% 
  dplyr::filter(Country == "Colombia" &
                  Model == "Model 3") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Variable",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = ""
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        strip.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())


# M3 - Peru --------------------------------------------------------------------

per3 <- df %>% 
  dplyr::filter(Variable == "GDP" | 
                  Variable == "CPI" | 
                  Variable == "CR" | 
                  Variable == "EXR" | 
                  Variable == "INTR"
  ) %>% 
  dplyr::filter(Country == "Peru" &
                  Model == "Model 3") %>% 
  dplyr::filter(Horizon == 1 | 
                  Horizon == 4 | 
                  Horizon == 16
  ) %>% 
  ggplot(aes(Horizon, 
             Response,
             fill = Shock
  )
  ) +   
  geom_bar(stat="identity", 
           position = position_dodge()#"stack"
           
           
  ) +
  facet_wrap("Variable",
             scales = "free_y",
             nrow = 1
  ) +
  theme(plot.title = element_text(size = 10, 
                                  face = "bold", 
                                  lineheight=1,
                                  hjust = 0
  ), 
  axis.text.x = element_text( size = rel(1.1), 
                              angle = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
  strip.text.x = element_text(size=16), 
  strip.text.y = element_text(size=12), 
  axis.title.x = element_text(size=12)
  ) + 
  scale_y_continuous(labels = scales::percent_format(),
                     breaks = breaks_extended(5),
                     position = "right",
                     sec.axis = dup_axis()
  ) +
  labs(x = "", 
       y = ""
  ) +
  scale_fill_manual("",
                    values=c("WSUP" = "#62b4ff",# '#64FF7D', WSUP
                             "WUNC" = "#35ff4d",#'#f9a65a', WUNC
                             "WDEM" = "#ca3b3b"#'#599ad3' WDEM
                             
                    )
  ) + 
  theme_minimal() + 
  ggtitle("") +
  theme(axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        strip.text.x = element_blank())


# M3 - Joining -----------------------------------------------------------------

m3 <- ggpubr::ggarrange(br3,
                        ch3,
                        col3,
                        per3,
                        nrow = 4,
                        legend = "none",
                        common.legend = FALSE)

m3 <- ggpubr::annotate_figure(m3, 
                              top = text_grob("Model 3")
)

# Joining M2 and M3
m2_m3 <- ggpubr::ggarrange(m3,
                           m2)

# Saving ------------------------------------------------------------------
setwd(here::here("FEVD"))
ggplot2::ggsave("m1_fevd.pdf", 
                plot = m1, 
                width = 40, 
                height = 20, 
                units = "cm"
)
ggplot2::ggsave("m2_m3_fevd.pdf", 
                plot = m2_m3, 
                width = 40, 
                height = 20, 
                units = "cm"
) 
ggplot2::ggsave("intl_fevd.pdf", 
                plot = intl, 
                width = 40, 
                height = 20, 
                units = "cm"
) 







