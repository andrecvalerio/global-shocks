# Path where the fevd files are stored
setwd(here::here("FEVD","fevd-matlab"))
# Identifying all files that are excel sheets in this path
my_sheets <- list.files(pattern = '*.xls')
# Reading all excel sheets
fevds <- lapply(my_sheets, readxl::read_excel, sheet = 2)
# Going back to the path where the routines are stored
setwd(here::here("FEVD","Code"))

# Calling the routines to generate plots
source("br_fevd.R")  # These four routines import and clean the data for each country
source("ch_fevd.R")
source("col_fevd.R")
source("per_fevd.R")
source("plot.R")     # This routine make final adjust to the data and generate the graphs in the paper

# Cleaning the workspace
rm(list = ls())

# Going back to the main folder
setwd(here::here())








