
# Preamble ----------------------------------------------------------------

# Function that take each spreadsheet and separate the shocks and
# neatly organize the data 
setwd(here::here("FEVD",
                 "Code"
                 )
      )

source("get_shocks_fevd.R")

# Path where the fevd files are stored
setwd(here::here("FEVD",
                 "Data"
                 )
      )

# FEV data for each model estimated
# m0 = counterfactual, m1 = benchmark, m2 = full model with alternative identification,
# m3 = WGDP + PCOM in the international side, m4 = Only PCOM in the international side,
# m5 = WGDP + VIX in the international side, m6 = VIX + PCOM in the international side,
# m7 = Only WGDP in the international side, m8 = Only VIX in the international side,
# m9 = benchmark without block recursion 

# Loop that load and clean the data
for (i in 0:9) {
  patt <- paste0("*VD_m",
                 i,
                 sep=""
                 )                                 # Pattern to load the spreadsheet
  
  name1 <- paste("xls_m",
                 i,
                 sep=""
                 )                                 # Placing holder for path name
  
  name2 <- paste("fev_m",
                 i,
                 sep=""
                 )                                 # Placing holder for file name
  
  tmp  <- assign(name1, 
                 list.files(pattern=patt)
                 )                                 # Temp file that holds the path for the spreadsheet
  
  tmp2 <- assign(name2,
                 lapply(tmp, 
                        readxl::read_excel, 
                        sheet = 2)
                 )                                 # Temp file that contains the data in the spreadsheets
  
  nam <- paste('m',
               i,
               sep=""
               )                                   # Final name of the data 
  
  assign(nam,
         lapply(tmp2,
                get_shocks_fevd,
                m=i
                )
         )                                         # Dataframe cleaned and organized in a list format
  
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

fevd <- bind_rows(by_model)

fevd <- fevd %>% 
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
                                  levels = c("WGDP",
                                             "VIX",
                                             "PCOM",
                                             "GDP",
                                             "CPI",
                                             "CR",
                                             "EXR",
                                             "INTR")
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
                )

# Keeping only the final data frame
rm(list=setdiff(ls(), 
                "fevd"
                )
   )

# Changing directory to code folder
setwd(here::here("FEVD",
                 "Code"
                 )
      )

source("plot_fevd.R")

# Changing directory to where plots will be saved
setwd(here::here("FEVD", 
                 "Figures"
                 )
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

# Plottting fevds of all models
for (m in 1:length(models)) {
  
  plot_fevd(models[m])
  
  # Full decomposition of GDP FEVD
  plot_fevd(models[m],
            1
            )
  
}

# FEVD international bloc
plot_fevd(0,
          0,
          0,
          intl=1
          )

# Plot comparisons across M1 vs CF & M1 vs M3 vs M4
plot_fevd(0,
          0,
          comp=1,
          0
          )





