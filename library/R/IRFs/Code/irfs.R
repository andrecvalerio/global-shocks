
# Preamble ----------------------------------------------------------------

# Function that take each spreadsheet and separate the shocks and
# neatly organize the data 
setwd(here::here("IRFs", 
                 "Code"
                 )
      )

source("get_shocks_irf.R")

# Path where the fevd files are stored
setwd(here::here("IRFs",
                 "Data"
                 )
      )

# IRF data for each model estimated
# m0 = counterfactual, m1 = benchmark, m2 = full model with alternative identification,
# m3 = WGDP + PCOM in the international side, m4 = Only PCOM in the international side,
# m5 = WGDP + VIX in the international side, m6 = VIX + PCOM in the international side,
# m7 = Only WGDP in the international side, m8 = Only VIX in the international side,
# m9 = benchmark without block recursion 

# Loop that load and clean the data
for (i in 0:9) {
  
  patt <- paste0("*IRF_m",
                 i,
                 sep=""
                 )                                # Pattern to load the spreadsheet
  
  name1 <- paste("xls_m",
                 i,
                 sep=""
                 )                                 # Placing holder for path name
  
  name2 <- paste("irf_m",
                 i,
                 sep=""
                 )                                 # Placing holder for file name
  
  tmp  <- assign(name1, 
                 list.files(pattern=patt
                            )
                 )                                 # Temp file that holds the path for the spreadsheet
  
  tmp2 <- assign(name2,
                 lapply(tmp, 
                        readxl::read_excel, 
                        sheet = 2
                        )
                 )                                 # Temp file that contains the data in the spreadsheets
  
  nam <- paste('m',
               i,
               sep=""
               )                                   # Final name of the data 
  
  assign(nam,
         lapply(tmp2,
                get_shocks_irf,
                m=i
                )
         )                      # Dataframe cleaned and organized in a list format
  
}

# Vector with each country name
country_list <- c("Brazil",
                  "Chile",
                  "Colombia",
                  "Peru"
                  )

# Combining all data sets into a list of list
list_models <- list(m1,
                    m2,
                    m3,
                    m4,
                    m5,
                    m6,
                    m7,
                    m8,
                    m9,
                    m0
                    )

# Loop to create the variable Country in each data set
for (j in 1:length(list_models)) {
  
  for (i in 1:length(country_list)) {
    
    list_models[[j]][[i]] <- list_models[[j]][[i]] %>% 
      dplyr::mutate(Country = country_list[[i]])
    
  }
  
}

# list_models is a list of lists. In each list, we have data for all countries for each estimated model
by_model <- lapply(list_models,
                   bind_rows
                   )

irfs <- bind_rows(by_model)

# Some final cleaning
irfs <- irfs %>% 
  dplyr::mutate(Variable = factor(Variable,
                                  levels = c("WGDP",
                                             "VIX",
                                             "PCOM",
                                             "GDP",
                                             "CPI",
                                             "CR",
                                             "EXR",
                                             "INTR"
                                             )
                                  )
  ) %>% 
  dplyr::mutate(Variable = recode_factor(Variable,
                                         "WGDP" = "World GDP",
                                         "VIX" = "VIX",
                                         "PCOM" = "Commodity Prices",
                                         "GDP" = "GDP",
                                         "CPI" = "CPI",
                                         "CR" = "Country Risk",
                                         "EXR" = "Exchange Rate",
                                         "INTR" = "Interest Rate"
                                         )
                ) %>% 
  dplyr::mutate(Shock = factor(Shock,
                                levels = c("Positive shock in WDEM",
                                           "Negative shock in WUNC",
                                           "Positive shock in WSUP",
                                           "Positive shock in LUNC",
                                           "FX",
                                           "LDEM",
                                           "LSUP",
                                           "MP")
                                )
                )

# Keeping only the final data frame
rm(list=setdiff(ls(), 
                "irfs"
                )
   )

# Changing directory
setwd(here::here("IRFs", 
                 "Code"
                 )
      )

source("plot_irf.R")

# Changing directory to where plots will be saved
setwd(here::here("IRFs", 
                 "Figures"
                 )
      )

# List of shocks for each model
shocks <- list(c("Positive shock in WDEM",
                 "Negative shock in WUNC",
                 "Positive shock in WSUP",
                 "Positive shock in LUNC"
                 ), # Models 0,1,2,9
               c("Positive shock in WDEM",
                 "Positive shock in WSUP",
                 "Positive shock in LUNC"
                 ), # Model 3
               c("Positive shock in WSUP",
                 "Positive shock in LUNC"
                 ), # Model 4
               c("Positive shock in WDEM",
                 "Negative shock in WUNC",
                 "Positive shock in LUNC"
                 ), # Model 5
               c("Negative shock in WUNC",
                 "Positive shock in WSUP",
                 "Positive shock in LUNC"
                 ), # Model 6
               c("Positive shock in WDEM",
                 "Positive shock in LUNC"
                 ), # Model 7
               c("Negative shock in WUNC",
                 "Positive shock in LUNC"
                 )  # Model 8
               ) 

# Vector of models' names
models <- c("Model 0",
            "Model 1",
            "Model 2",
            "Model 3",
            "Model 4",
            "Model 5",
            "Model 6",
            "Model 7",
            "Model 8",
            "Model 9")


# Plotting all shocks for all models --------------------------------------

for (m in 1:length(models)) {
  
    if (m == 1 | 
        m == 2 | 
        m == 3 | 
        m == 10
        ) {
      
      for (s in 1:length(shocks[[1]])) {
        
        plot_irf(models[m], shocks[[1]][s])
      }
      
    } else if (m == 4) {
      
      for (s in 1:length(shocks[[2]])) {
        
        plot_irf(models[m], shocks[[2]][s])
        
      }
      
    } else if (m == 5) {
      
      for (s in 1:length(shocks[[3]])) {
        
        plot_irf(models[m], shocks[[3]][s])
        
      }
      
    } else if (m == 6) {
      
      for (s in 1:length(shocks[[4]])) {
        
        plot_irf(models[m], shocks[[4]][s])
        
      }
      
    } else if (m == 7) {
      
      for (s in 1:length(shocks[[5]])) {
        
        plot_irf(models[m], shocks[[5]][s])
        
      }
      
    } else if (m == 8) {
      
      for (s in 1:length(shocks[[6]])) {
        
        plot_irf(models[m], shocks[[6]][s])
        
      }
      
    } else if (m == 9) {
      
      for (s in 1:length(shocks[[7]])) {
        
        plot_irf(models[m], shocks[[7]][s])
        
      }
      
    }
    
}


# Plotting international bloc for all models ------------------------------

for (mm in 1:length(models)) {
  
  for (ss in 1:length(shocks[[1]])) {
    
    plot_irf(models[mm],
             shocks[[1]][ss],
             1
             )
    
  }
  
}
  

# M1 vs CF ----------------------------------------------------------------

setwd(here::here("IRFs",
                 "Figures"
                 )
      )

xticks <- seq(min(0),
              max(16),
              by = 2
              )

irfs %>% dplyr::filter(Model == "Model 1" |  
                  Model == "Model 0") %>% 
  dplyr::mutate(Model = recode(Model,
                               "Model 1" = "Benchmark",
                               "Model 0" = "Counterfactual"
                               )
                ) %>% 
  dplyr::filter(Shock == "Positive shock in WDEM") %>% 
  dplyr::filter(Variable != "World GDP" &
                  Variable != "VIX" &
                  Variable != "Commodity Prices" &
                  Variable != "Country Risk"
                ) %>% 
  ggplot(aes(x = Horizon,
             y = Response,
             color = Model
             )
         ) +
  geom_line() +
  facet_grid(Variable ~ Country,
             scales = "free",
             space = "fixed"
             ) +
  scale_x_continuous("",
                     expand = c(0, 0), 
                     breaks = xticks
                     ) +
  scale_y_continuous("",
                     breaks = scales::pretty_breaks(n = 7),
                     labels = scales::percent_format(),
                     position = "right",
                     sec.axis = dup_axis()
                     ) + 
  geom_hline(yintercept = 0) + 
  theme_bw() + 
  geom_blank() + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5),
        strip.placement = "outside", 
        strip.background = element_blank(),
        strip.text.x = element_text(size=16), 
        strip.text.y = element_text(size=12),
        axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        axis.title.y.right = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_text(margin(0,20,0,0)),
        legend.position = "bottom"
        ) +
  scale_color_manual("",
                    values = c("Benchmark" = "blue",
                               "Counterfactual" = "red"
                               )
                    ) +
  ggplot2::ggsave("wdem_m1_cf_irf.pdf", 
                  width = 40, 
                  height = 20, 
                  units = "cm"
                  )

irfs %>% dplyr::filter(Model == "Model 1" |  
                         Model == "Model 0"
                       ) %>% 
  dplyr::mutate(Model = recode(Model,
                               "Model 1" = "Benchmark",
                               "Model 0" = "Counterfactual"
                               )
                ) %>% 
  dplyr::filter(Shock == "Negative shock in WUNC") %>% 
  dplyr::filter(Variable != "World GDP" &
                  Variable != "VIX" &
                  Variable != "Commodity Prices" &
                  Variable != "Country Risk"
                ) %>% 
  ggplot(aes(x = Horizon,
             y = Response,
             color = Model
             )
         ) +
  geom_line() +
  facet_grid(Variable ~ Country,
             scales = "free",
             space = "fixed"
             ) +
  scale_x_continuous("",
                     expand = c(0, 0), 
                     breaks = xticks
                     ) +
  scale_y_continuous("",
                     breaks = scales::pretty_breaks(n = 7),
                     labels = scales::percent_format(),
                     position = "right",
                     sec.axis = dup_axis()
                     ) + 
  geom_hline(yintercept = 0) + 
  theme_bw() + 
  geom_blank() + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5),
        strip.placement = "outside", 
        strip.background = element_blank(),
        strip.text.x = element_text(size=16), 
        strip.text.y = element_text(size=12),
        axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        axis.title.y.right = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_text(margin(0,20,0,0)),
        legend.position = "bottom"
        ) +
  scale_color_manual("",
                     values = c("Benchmark" = "blue",
                                "Counterfactual" = "red"
                                )
                     ) +
  ggplot2::ggsave("wunc_m1_cf_irf.pdf", 
                  width = 40, 
                  height = 20, 
                  units = "cm"
                  )


irfs %>% dplyr::filter(Model == "Model 1" |  
                         Model == "Model 0"
                       ) %>% 
  dplyr::mutate(Model = recode(Model,
                               "Model 1" = "Benchmark",
                               "Model 0" = "Counterfactual"
                               )
                ) %>% 
  dplyr::filter(Shock == "Positive shock in WSUP") %>% 
  dplyr::filter(Variable != "World GDP" &
                  Variable != "VIX" &
                  Variable != "Commodity Prices" &
                  Variable != "Country Risk"
                ) %>% 
  ggplot(aes(x = Horizon,
             y = Response,
             color = Model
             )
         ) +
  geom_line() +
  facet_grid(Variable ~ Country,
             scales = "free",
             space = "fixed"
             ) +
  scale_x_continuous("",
                     expand = c(0, 0), 
                     breaks = xticks
                     ) +
  scale_y_continuous("",
                     breaks = scales::pretty_breaks(n = 7),
                     labels = scales::percent_format(),
                     position = "right",
                     sec.axis = dup_axis()
                     ) + 
  geom_hline(yintercept = 0) + 
  theme_bw() + 
  geom_blank() + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5),
        strip.placement = "outside", 
        strip.background = element_blank(),
        strip.text.x = element_text(size=16), 
        strip.text.y = element_text(size=12),
        axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        axis.title.y.right = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_text(margin(0,20,0,0)),
        legend.position = "bottom"
        ) +
  scale_color_manual("",
                     values = c("Benchmark" = "blue",
                                "Counterfactual" = "red"
                                )
                     ) +
  ggplot2::ggsave("wsup_m1_cf_irf.pdf", 
                  width = 40, 
                  height = 20, 
                  units = "cm"
                  )


irfs %>% dplyr::filter(Model == "Model 1" |  
                         Model == "Model 0"
                       ) %>% 
  dplyr::mutate(Model = recode(Model,
                               "Model 1" = "Benchmark",
                               "Model 0" = "Counterfactual"
                               )
                ) %>% 
  dplyr::filter(Shock == "Negative shock in WUNC") %>% 
  dplyr::filter(Variable != "World GDP" &
                  Variable != "VIX" &
                  Variable != "Commodity Prices" &
                  Variable != "Country Risk"
                ) %>% 
  ggplot(aes(x = Horizon,
             y = Response,
             color = Model
             )
         ) +
  geom_line() +
  facet_grid(Variable ~ Country,
             scales = "free",
             space = "fixed"
             ) +
  scale_x_continuous("",
                     expand = c(0, 0), 
                     breaks = xticks
                     ) +
  scale_y_continuous("",
                     breaks = scales::pretty_breaks(n = 7),
                     labels = scales::percent_format(),
                     position = "right",
                     sec.axis = dup_axis()
                     ) + 
  geom_hline(yintercept = 0) + 
  theme_bw() + 
  geom_blank() + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5),
        strip.placement = "outside", 
        strip.background = element_blank(),
        strip.text.x = element_text(size=16), 
        strip.text.y = element_text(size=12),
        axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.title.y.left = element_blank(),
        axis.title.y.right = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_text(margin(0,20,0,0)),
        legend.position = "bottom"
        ) +
  scale_color_manual("",
                     values = c("Benchmark" = "blue",
                                "Counterfactual" = "red"
                                )
                     ) +
  ggplot2::ggsave("wunc_m1_cf_irf.pdf", 
                  width = 40, 
                  height = 20, 
                  units = "cm"
                  )




