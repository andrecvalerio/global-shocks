# Packages necessary to perform the analysis
pkgs <- list("ggthemes","tidyverse","ggpubr", "scales")
# From the tidyverse package I use the following packages
# dplyr, readxl, here, ggplot2


# Installing the packages - comment this if you already have installed it
#lapply(pkgs,install.packages)

# Calling the packages
lapply(pkgs,library,character.only=TRUE)

# IRF Section -------------------------------------------------------------
setwd(here::here("IRFs","Code"))

# Calling the routines
source("wdem.R")
source("wunc.R")
source("wsup.R")
source("intl.R")


# FEVD Section ------------------------------------------------------------
setwd(here::here("FEVD","Code"))

# Calling the routines
source("fevd.R")

