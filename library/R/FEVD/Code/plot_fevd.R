plot_fevd <- function(m, full_gdp = 0, comp = 0, intl = 0) {
  

# Regular plots for all models --------------------------------------------

  if (full_gdp == 0 & 
      comp == 0 & 
      intl == 0
      ) {
    
    fevd %>% dplyr::filter(Model == m) %>% 
      dplyr::filter(Variable != "World GDP" &
                      Variable != "VIX" & 
                      Variable != "Commodity Prices"
                    ) %>% 
      dplyr::filter(if (Model == "Model 0") Variable != "Country Risk" 
                    else Variable == "Country Risk" | 
                      Variable == "Exchange Rate" | 
                      Variable == "GDP" | 
                      Variable == "CPI" | 
                      Variable == "Interest Rate"
                    ) %>% 
      dplyr::filter(Shock == "WDEM" |
                      Shock == "WUNC" |
                      Shock == "WSUP" |
                      Shock == "LUNC"
                    ) %>% 
      dplyr::filter(Horizon == 4 |
                      Horizon == 8 |
                      Horizon == 16
                    ) %>% 
      ggplot(aes(Horizon,
                 Response,
                 fill = Shock
                 )
             ) +
      geom_bar(stat="identity",
               position = position_dodge()
               ) +
      facet_grid(Country ~ Variable,
                 scales = "free_y"
                 ) +
      theme(plot.title = element_text(size = 10,
                                      face = "bold",
                                      lineheight=1,
                                      hjust = 0
                                      ),
      axis.text.x = element_text(size = rel(1.1),
                                 angle = 10
                                 ),
      legend.position = "bottom",
      legend.title = element_blank(),
      axis.title.y = element_text(margin(0,20,0,0)),
      strip.text.x = element_text(size=16),
      strip.text.y = element_text(size=12),
      axis.title.x = element_text(size=12)
      ) +
      scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                         breaks = breaks_extended(5),
                         position = "right",
                         sec.axis = dup_axis()
                         ) +
      scale_fill_manual("",
                        values=c("WSUP" = "#62b4ff",
                                 "WUNC" = "#35ff4d",
                                 "WDEM" = "#ca3b3b",
                                 "LUNC" = "#f9c22e"
                                 )
                        ) +
      theme_minimal() +
      ggtitle("") +
      theme(axis.text.y.right = element_blank(),
            axis.ticks.y.right = element_blank(),
            axis.title.y.left = element_blank(),
            axis.title.y.right = element_blank(),
            axis.title.x = element_blank(),
            strip.text.y = element_text(size = 12),
            strip.text.x = element_text(size = 12)
            ) +
      ggplot2::ggsave(paste("m",
                            substr(m,
                                   7,
                                   7
                                   ),
                            "_fevd.pdf", 
                            sep = ""
                            ),
                      width = 40,
                      height = 20,
                      units = "cm"
                      )
    
  } else if (full_gdp != 0 & 
             comp == 0 & 
             intl == 0
             )  {
    
# Full decomposition for GDP - Models 1 and CF ----------------------------

    fevd %>% dplyr::mutate(Shock = factor(Shock, 
                                          levels = c("WDEM",
                                                     "WUNC",
                                                     "WSUP",
                                                     "FX",
                                                     "LDEM",
                                                     "LUNC",
                                                     "LSUP",
                                                     "MP"
                                                     )
                                          )
                           ) %>% 
      dplyr::mutate(Shock = recode_factor(Shock,
                                          "WDEM" = "World Demand",
                                          "WUNC" = "World Uncertainty",
                                          "WSUP" = "World Supply",
                                          "FX"   = "Forex Market",
                                          "LDEM" = "Local Demand",
                                          "LUNC" = "Local Uncertainty",
                                          "LSUP" = "Local Supply",
                                          "MP"   = "Monetary Policy"
                                          )
                    ) %>% 
      dplyr::filter(Variable == "GDP" & 
                      Model == m
                    ) %>% 
      dplyr::filter(Horizon == 4 | 
                      Horizon == 8 |
                      Horizon == 16
                    ) %>% 
      ggplot(aes(Horizon, 
                 Response,
                 fill = Country
                 )
             ) +   
      geom_bar(stat="identity", 
               position = position_dodge()
               ) +
      facet_wrap(vars(Shock),
                 scales = "free_y",
                 nrow = 2
                 ) +
      theme(plot.title = element_text(size = 10, 
                                      face = "bold", 
                                      lineheight=1,
                                      hjust = 0
                                      ), 
      axis.text.x = element_text(size = rel(1.1), 
                                 angle = 10
                                 ),
      legend.position = "bottom",
      legend.title = element_blank(),
      axis.title.y = element_text(margin(0,20,0,0)),
      strip.text.x = element_text(size=16), 
      strip.text.y = element_text(size=12), 
      axis.title.x = element_text(size=12)
      ) + 
      scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                         breaks = breaks_extended(5),
                         position = "right",
                         sec.axis = dup_axis()
                         ) +
      scale_fill_manual("",
                        values=c("Brazil" = "#053c5e",
                                 "Chile" = "#7cffc4",
                                 "Colombia" = "#db222a",
                                 "Peru" = "#d4b483" 
                                 )
                        ) + 
      theme_minimal() + 
      ggtitle("") +
      theme(axis.text.y.right = element_blank(),
            axis.ticks.y.right = element_blank(),
            axis.title.y.left = element_blank(),
            axis.title.y.right = element_blank(),
            axis.title.x = element_blank(),
            strip.text.y = element_text(size = 12),
            strip.text.x = element_text(size = 12)
            ) + 
      ggplot2::ggsave(paste("m",
                            substr(m,
                                   7,
                                   7
                                   ),
                            "_fevd_gdp.pdf", 
                            sep = ""
                            ), 
                      width = 40, 
                      height = 20, 
                      units = "cm"
                      )
    
  } else if (comp != 0 & 
             full_gdp == 0 & 
             intl == 0
             ) {
    
# M1 vs CF ----------------------------------------------------------------
    
    shocks <- c("WDEM Shock", 
                "WUNC Shock", 
                "WSUP Shock", 
                "LUNC Shock"
                )
    
    countries <- c("Brazil", 
                   "Chile", 
                   "Peru", 
                   "Colombia"
                   )
    
    for (j in 1:length(countries)) {
      
      name <- paste(countries[j],
                    "_",
                    substr(shocks[1],
                           1,
                           4
                           ),
                    sep=""
                    )
      
      tmp <- fevd %>% dplyr::filter(Variable != "World GDP" & 
                                      Variable != "VIX" & 
                                      Variable != "Commodity Prices" & 
                                      Variable != "Country Risk"
                                    ) %>% 
        dplyr::filter(Shock == "WDEM") %>%  
        dplyr::mutate(Shock = recode(Shock,
                                     "WDEM" = "WDEM Shock"
                                     )
                      ) %>% 
        dplyr::filter(Model == "Model 1" | 
                        Model == "Model 0"
                      ) %>% 
        dplyr::filter(Horizon == 4 | 
                        Horizon == 8 | 
                        Horizon == 16
                      ) %>%
        dplyr::filter(Country == countries[j]) %>% 
        dplyr::mutate(Model = recode(Model,
                                     "Model 1" = "Benchmark",
                                     "Model 0" = "Counterfactual"
                                     )
                      ) %>% 
        ggplot(aes(Horizon, 
                   Response,
                   fill = Model
                   )
               ) +   
        geom_bar(stat="identity", 
                 position = position_dodge()
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
                                    angle = 10
                                    ),
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.y = element_text(margin(0,20,0,0)),#element_blank(),
        strip.text.x = element_text(size=16), 
        strip.text.y = element_text(size=12), 
        axis.title.x = element_text(size=12)
        ) + 
        scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                           breaks = breaks_extended(5),
                           position = "right",
                           sec.axis = dup_axis()
                           ) +
        labs(y = "WDEM Shock"
             ) +
        scale_fill_manual("",
                          values=c("Counterfactual" = "#de6b48",
                                   "Benchmark" = "#7dbbc3"
                                   )
                          ) + 
        theme_minimal() + 
        theme(axis.text.y.right = element_blank(),
              axis.ticks.y.right = element_blank(),
              axis.title.y.left = element_blank(),
              axis.title.x = element_blank(),
              axis.ticks.x = element_blank(),
              axis.text.x = element_blank()) +
        ggtitle("") 
      
      assign(name,
             tmp
             )
      
    }
    
    for (j in 1:length(countries)) {
      
      for (i in 2:length(shocks)) {
        
        name <- paste(countries[j],
                      "_",
                      substr(shocks[i],
                             1,
                             4
                             ),
                      sep=""
                      )
        
        tmp <- fevd %>% dplyr::filter(Shock == "WDEM" |
                                        Shock == "WUNC" |
                                        Shock == "WSUP" |
                                        Shock == "LUNC"
                                      ) %>% 
          dplyr::mutate(Shock = recode(Shock,
                                       "WDEM" = "WDEM Shock",
                                       "WUNC" = "WUNC Shock",
                                       "WSUP" = "WSUP Shock",
                                       "LUNC" = "LUNC Shock"
                                       )
                        ) %>% 
          dplyr::filter(Model == "Model 1" | 
                          Model == "Model 0"
                        ) %>% 
          dplyr::filter(Variable != "World GDP" &
                          Variable != "VIX" &
                          Variable != "Commodity Prices" &
                          Variable != "Country Risk"
                        ) %>% 
          dplyr::filter(Shock == shocks[i]) %>% 
          dplyr::filter(Country == countries[j]) %>% 
          dplyr::mutate(Model = recode(Model,
                                       "Model 1" = "Benchmark",
                                       "Model 0" = "Counterfactual"
                                       )
                        ) %>% 
          dplyr::filter(Horizon == 4 |
                          Horizon == 8 |
                          Horizon == 16
                        ) %>% 
          ggplot(aes(Horizon, 
                     Response,
                     fill = Model
                     )
                 ) +   
          geom_bar(stat="identity", 
                   position = position_dodge()
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
          axis.text.x = element_text(size = rel(1.1),
                                     angle = 10
                                     ),
          legend.position = "bottom",
          legend.title = element_blank(),
          axis.title.y = element_blank(),
          strip.text.x = element_blank(),
          strip.text.y = element_blank(),
          axis.title.x = element_text(size=12)
          ) + 
          scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                             breaks = breaks_extended(5),
                             position = "right",
                             sec.axis = dup_axis()
                             ) +
          labs(x = "",
               y = shocks[i]
               ) +
          scale_fill_manual("",
                            values=c("Counterfactual" = "#de6b48",
                                     "Benchmark" = "#7dbbc3"
                                     )
                            ) + 
          theme_minimal() + 
          theme(axis.text.y.right = element_blank(),
                axis.ticks.y.right = element_blank(),
                axis.title.y.left = element_blank(),
                axis.title.x = element_blank(),
                axis.ticks.x = element_blank(),
                axis.text.x = element_blank(),
                strip.text.x = element_blank()
                ) +
          ggtitle("") 
        
        assign(name,
               tmp
               )
        
      }
      
    }
    
    br_comp <- ggpubr::ggarrange(Brazil_WDEM,
                                 Brazil_WUNC,
                                 Brazil_WSUP,
                                 Brazil_LUNC, 
                                 nrow=4,
                                 legend='right',
                                 common.legend=TRUE
                                 )
    
    ch_comp <- ggpubr::ggarrange(Chile_WDEM,
                                 Chile_WUNC,
                                 Chile_WSUP,
                                 Chile_LUNC, 
                                 nrow=4,
                                 legend='right',
                                 common.legend=TRUE
                                 )
    
    col_comp <- ggpubr::ggarrange(Colombia_WDEM,
                                  Colombia_WUNC,
                                  Colombia_WSUP,
                                  Colombia_LUNC, 
                                  nrow=4,
                                  legend='right',
                                  common.legend=TRUE
                                  )
    
    per_comp <- ggpubr::ggarrange(Peru_WDEM,
                                  Peru_WUNC,
                                  Peru_WSUP,
                                  Peru_LUNC, 
                                  nrow=4,
                                  legend='right',
                                  common.legend=TRUE
                                  )
    
    ggplot2::ggsave("br_m1cf_fevd.pdf",
                    plot = br_comp,
                    width = 40,
                    height = 20,
                    units = "cm"
                    )
    
    ggplot2::ggsave("ch_m1cf_fevd.pdf",
                    plot = br_comp,
                    width = 40,
                    height = 20,
                    units = "cm"
                    )
    
    ggplot2::ggsave("col_m1cf_fevd.pdf",
                    plot = br_comp,
                    width = 40,
                    height = 20,
                    units = "cm"
                    )
    
    ggplot2::ggsave("per_m1cf_fevd.pdf",
                    plot = br_comp,
                    width = 40,
                    height = 20,
                    units = "cm"
                    )
    
    
# M1 vs M3 vs M4 ----------------------------------------------------------
    
    shocks <- c("WDEM Shock", 
                "WSUP Shock", 
                "LUNC Shock"
                )
    
    for (j in 1:length(countries)) {
      
      name <- paste(countries[j],
                    "_",
                    substr(shocks[1],
                           1,
                           4
                           ),
                    sep=""
                    )
      
      tmp <- fevd %>% dplyr::filter(Variable != "World GDP" & 
                                      Variable != "VIX" & 
                                      Variable != "Commodity Prices" & 
                                      Variable != "Country Risk"
                                    ) %>% 
        dplyr::filter(Shock == "WDEM") %>% 
        dplyr::mutate(Shock = recode(Shock,
                                     "WDEM" = "WDEM Shock"
                                     )
                      ) %>% 
        dplyr::filter(Model == "Model 1" | 
                        Model == "Model 3" | 
                        Model == "Model 4"
                      ) %>% 
        dplyr::filter(Horizon == 4 | 
                        Horizon == 8 | 
                        Horizon == 16
                      ) %>%
        dplyr::filter(Country == countries[j]) %>% 
        ggplot(aes(Horizon, 
                   Response,
                   fill = Model
                   )
               ) +   
        geom_bar(stat="identity", 
                 position = position_dodge()
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
                                    angle = 10
                                    ),
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.y = element_text(margin(0,20,0,0)),
        strip.text.x = element_text(size=16), 
        strip.text.y = element_text(size=12), 
        axis.title.x = element_text(size=12)
        ) + 
        scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                           breaks = breaks_extended(5),
                           position = "right",
                           sec.axis = dup_axis()
                           ) +
        labs(y = "WDEM Shock"
             ) +
        scale_fill_manual("",
                          values=c("Model 1" = "#b0d0d3",
                                   "Model 3" = "#c08497",
                                   "Model 4" = "#f7af9d"
                                   )
                          ) + 
        theme_minimal() + 
        theme(axis.text.y.right = element_blank(),
              axis.ticks.y.right = element_blank(),
              axis.title.y.left = element_blank(),
              axis.title.x = element_blank(),
              axis.ticks.x = element_blank(),
              axis.text.x = element_blank()) +
        ggtitle("") 
      
      assign(name,
             tmp
             )
      
    }
    
    for (j in 1:length(countries)) {
      
      for (i in 2:length(shocks)) {
        
        name <- paste(countries[j],
                      "_",
                      substr(shocks[i],
                             1,
                             4
                             ),
                      sep=""
                      )
        
        tmp <- fevd %>% dplyr::filter(Shock == "WDEM" |
                                        Shock == "WUNC" |
                                        Shock == "WSUP" |
                                        Shock == "LUNC"
                                      ) %>% 
          dplyr::mutate(Shock = recode(Shock,
                                       "WDEM" = "WDEM Shock",
                                       "WUNC" = "WUNC Shock",
                                       "WSUP" = "WSUP Shock",
                                       "LUNC" = "LUNC Shock"
                                       )
                        ) %>% 
          dplyr::filter(Model == "Model 1" | 
                          Model == "Model 3" |
                          Model == "Model 4"
                        ) %>% 
          dplyr::filter(Variable != "World GDP" &
                          Variable != "VIX" &
                          Variable != "Commodity Prices" &
                          Variable != "Country Risk"
                        ) %>% 
          dplyr::filter(Shock == shocks[i]) %>% 
          dplyr::filter(Country == countries[j]) %>% 
          dplyr::filter(Horizon == 4 |
                          Horizon == 8 |
                          Horizon == 16
                        ) %>% 
          ggplot(aes(Horizon, 
                     Response,
                     fill = Model
                     )
                 ) +   
          geom_bar(stat="identity", 
                   position = position_dodge()
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
          axis.text.x = element_text(size = rel(1.1),
                                     angle = 10
                                     ),
          legend.position = "bottom",
          legend.title = element_blank(),
          axis.title.y = element_blank(),
          strip.text.x = element_blank(),
          strip.text.y = element_blank(),
          axis.title.x = element_text(size=12)
          ) + 
          scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                             breaks = breaks_extended(5),
                             position = "right",
                             sec.axis = dup_axis()
                             ) +
          labs(x = "",
               y = shocks[i]
               ) +
          scale_fill_manual("",
                            values=c("Model 1" = "#b0d0d3",
                                     "Model 3" = "#c08497",
                                     "Model 4" = "#f7af9d"
                                     )
                            ) + 
          theme_minimal() + 
          theme(axis.text.y.right = element_blank(),
                axis.ticks.y.right = element_blank(),
                axis.title.y.left = element_blank(),
                axis.title.x = element_blank(),
                axis.ticks.x = element_blank(),
                axis.text.x = element_blank(),
                strip.text.x = element_blank()) +
          ggtitle("") 
        
        assign(name,
               tmp
               )
        
      }
      
    }
    
    br1 <- ggpubr::ggarrange(Brazil_WDEM, 
                             nrow = 1, 
                             legend = "none"
                             )
    
    br2 <- ggpubr::ggarrange(Brazil_WSUP,
                             nrow = 1,
                             legend = "none"
                             )
    
    br3 <- ggpubr::ggarrange(Brazil_LUNC, 
                             nrow = 1, 
                             legend = "bottom"
                             )
    
    ch1 <- ggpubr::ggarrange(Chile_WDEM, 
                             nrow = 1, 
                             legend = "none"
                             )
    
    ch2 <- ggpubr::ggarrange(Chile_WSUP, 
                             nrow = 1, 
                             legend = "none"
                             )
    
    ch3 <- ggpubr::ggarrange(Chile_LUNC, 
                             nrow = 1, 
                             legend = "bottom"
                             )
    
    col1 <- ggpubr::ggarrange(Colombia_WDEM,
                              nrow = 1, 
                              legend = "none"
                              )
    
    col2 <- ggpubr::ggarrange(Colombia_WSUP,
                              nrow = 1,
                              legend = "none"
                              )
    
    col3 <- ggpubr::ggarrange(Colombia_LUNC,
                              nrow = 1,
                              legend = "bottom"
                              )
    
    per1 <- ggpubr::ggarrange(Peru_WDEM, 
                              nrow = 1,
                              legend = "none"
                              )
    
    per2 <- ggpubr::ggarrange(Peru_WSUP,
                              nrow = 1,
                              legend = "none"
                              )
    
    per3 <- ggpubr::ggarrange(Peru_LUNC,
                              nrow = 1, 
                              legend = "bottom"
                              )
    
    br_comp <- ggpubr::ggarrange(br1,
                                 br2,
                                 br3, 
                                 nrow=3,
                                 legend='bottom',
                                 common.legend=TRUE
                                 )
    
    ch_comp <- ggpubr::ggarrange(ch1,
                                 ch2,
                                 ch3,
                                 nrow=3,
                                 legend='bottom',
                                 common.legend=TRUE
                                 )
    
    col_comp <- ggpubr::ggarrange(col1,
                                  col2,
                                  col3, 
                                  nrow=3,
                                  legend='bottom',
                                  common.legend=TRUE
                                  )
    
    per_comp <- ggpubr::ggarrange(per1,
                                  per2,
                                  per3, 
                                  nrow=3,
                                  legend='bottom',
                                  common.legend=TRUE
                                  )
    
    ggplot2::ggsave("br_m1m3m4_fevd.pdf",
                    plot = br_comp,
                    width = 40,
                    height = 20,
                    units = "cm"
                    )
    
    ggplot2::ggsave("ch_m1m3m4_fevd.pdf",
                    plot = br_comp,
                    width = 40,
                    height = 20,
                    units = "cm"
                    )
    
    ggplot2::ggsave("col_m1m3m4_fevd.pdf",
                    plot = br_comp,
                    width = 40,
                    height = 20,
                    units = "cm"
                    )
    
    ggplot2::ggsave("per_m1m3m4_fevd.pdf",
                    plot = br_comp,
                    width = 40,
                    height = 20,
                    units = "cm"
                    )
    
  } else if (full_gdp == 0 & 
             comp == 0 & 
             intl !=0
             ) {

# International bloc ------------------------------------------------------

    fevd %>% dplyr::filter(Country == "Brazil") %>% 
      dplyr::filter(Variable == "World GDP" | 
                      Variable == "VIX" | 
                      Variable == "Commodity Prices"
                    ) %>% 
      dplyr::mutate(Variable = factor(Variable,
                                      levels = c("World GDP",
                                                 "Commodity Prices",
                                                 "VIX"
                                                 )
                                      )
                    ) %>% 
      dplyr::filter(Shock == "WDEM" | 
                      Shock == "WUNC" | 
                      Shock == "WSUP"
                    ) %>% 
      dplyr::filter(Model == "Model 1" | 
                      Model == "Model 3"
                    ) %>%
      dplyr::filter(Horizon == 4 | 
                      Horizon == 8 | 
                      Horizon == 16
                    ) %>% 
      ggplot(aes(Horizon, 
                 Response,
                 fill = Shock
                 )
             ) +   
      geom_bar(stat="identity", 
               position = position_dodge()
               ) +
      facet_grid(Variable ~ Model,
                 scales = "free_y"
                 ) +
      theme(plot.title = element_text(size = 10, 
                                      face = "bold", 
                                      lineheight=1,
                                      hjust = 0
                                      ), 
      axis.text.x = element_text( size = rel(1.1), 
                                  angle = 10
                                  ),
      legend.position = "bottom",
      legend.title = element_blank(),
      axis.title.y = element_text(margin(0,20,0,0)),
      strip.text.x = element_text(size=16), 
      strip.text.y = element_text(size=12), 
      axis.title.x = element_text(size=12)
      ) + 
      scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                         breaks = breaks_extended(5),
                         position = "right",
                         sec.axis = dup_axis()
                         ) +
      scale_fill_manual("",
                        values=c("WSUP" = "#62b4ff",
                                 "WUNC" = "#35ff4d",
                                 "WDEM" = "#ca3b3b"
                                 )
                        ) + 
      theme_minimal() + 
      ggtitle("") +
      theme(axis.text.y.right = element_blank(),
            axis.ticks.y.right = element_blank(),
            axis.title.y.left = element_blank(),
            axis.title.y.right = element_blank(),
            axis.title.x = element_blank(),
            strip.text.y = element_text(size = 12),
            strip.text.x = element_text(size = 12)
            ) +
      ggplot2::ggsave("intl_fevd.pdf", 
                      width = 40, 
                      height = 20, 
                      units = "cm"
                      )
    
  }
  
}