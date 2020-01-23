# Set path to where excel sheets are stored
setwd(here::here("IRFs",
                 "Data",
                 "WGDP"
                 )
      )

# Loading the dataset for the world demand shock
wgdp_sheets <- list.files(pattern = '*wgdp.xls')
wgdp_irf <- lapply(wgdp_sheets, 
                   readxl::read_excel, 
                   sheet = 2
                   )

# Individualizing the datasets
br_low  <- wgdp_irf[[1]]
br_up   <- wgdp_irf[[2]]
br      <- wgdp_irf[[3]]
ch_low  <- wgdp_irf[[4]]
ch_up   <- wgdp_irf[[5]]
ch      <- wgdp_irf[[6]]
col_low <- wgdp_irf[[7]]
col_up  <- wgdp_irf[[8]]
col     <- wgdp_irf[[9]]
per_low <- wgdp_irf[[10]]
per_up  <- wgdp_irf[[11]]
per     <- wgdp_irf[[12]]

# Tidying the data so we have a data frame with
# only Horizon, Variable, Response, Low, Up and Country as columns
# This allows us to use tidyverse functions and generate the plots
# more easily
# I do this for each country and then group into one big data frame
br <- tidyr::gather(br, 
                    key = Variable, 
                    value = Response, 
                    GDP, 
                    CPI, 
                    WGDP, 
                    VIX, 
                    PCOM, 
                    CR, 
                    EXR, 
                    INTR
                    )

br_low <- tidyr::gather(br_low, 
                        key = Variable, 
                        value = Low, 
                        GDP, 
                        CPI, 
                        WGDP, 
                        VIX, 
                        PCOM, 
                        CR, 
                        EXR, 
                        INTR
                        )

br_up <- tidyr::gather(br_up, 
                       key = Variable, 
                       value = Up, 
                       GDP, 
                       CPI, 
                       WGDP, 
                       VIX, 
                       PCOM, 
                       CR, 
                       EXR, 
                       INTR
                       )

br <- br %>% 
  dplyr::bind_cols(br,
                   br_low,
                   br_up
  ) %>% 
  dplyr::select(Horizon,
                Variable,
                Response,
                Low,
                Up
  ) %>% 
  dplyr::mutate(Country = (rep("Brazil",nrow(br))))

ch <- tidyr::gather(ch, 
                    key = Variable, 
                    value = Response, 
                    GDP, 
                    CPI, 
                    WGDP, 
                    VIX, 
                    PCOM, 
                    CR, 
                    EXR, 
                    INTR
)

ch_low <- tidyr::gather(ch_low, 
                        key = Variable, 
                        value = Low, 
                        GDP, 
                        CPI, 
                        WGDP, 
                        VIX, 
                        PCOM, 
                        CR, 
                        EXR, 
                        INTR
)

ch_up <- tidyr::gather(ch_up, 
                       key = Variable, 
                       value = Up, 
                       GDP, 
                       CPI, 
                       WGDP, 
                       VIX, 
                       PCOM, 
                       CR, 
                       EXR, 
                       INTR
)

ch <- ch %>% 
  dplyr::bind_cols(ch,
                   ch_low,
                   ch_up) %>% 
  dplyr::select(Horizon,
                Variable,
                Response,
                Low,
                Up) %>% 
  dplyr::mutate(Country = (rep("Chile",nrow(ch))))

col <- tidyr::gather(col, 
                     key = Variable, 
                     value = Response, 
                     GDP, 
                     CPI, 
                     WGDP, 
                     VIX, 
                     PCOM, 
                     CR, 
                     EXR, 
                     INTR
)

col_low <- tidyr::gather(col_low, 
                         key = Variable, 
                         value = Low, 
                         GDP, 
                         CPI, 
                         WGDP, 
                         VIX, 
                         PCOM, 
                         CR, 
                         EXR, 
                         INTR
)

col_up <- tidyr::gather(col_up, 
                        key = Variable, 
                        value = Up, 
                        GDP, 
                        CPI, 
                        WGDP, 
                        VIX, 
                        PCOM, 
                        CR, 
                        EXR, 
                        INTR
)

col <- col %>% 
  dplyr::bind_cols(col,
                   col_low,
                   col_up
  ) %>% 
  dplyr::select(Horizon,
                Variable,
                Response,
                Low,
                Up
  ) %>% 
  dplyr::mutate(Country = (rep("Colombia",nrow(col))))

per <- tidyr::gather(per, 
                     key = Variable, 
                     value = Response, 
                     GDP, 
                     CPI, 
                     WGDP, 
                     VIX, 
                     PCOM, 
                     CR, 
                     EXR, 
                     INTR
                     )

per_low <- tidyr::gather(per_low, 
                         key = Variable, 
                         value = Low, 
                         GDP, 
                         CPI, 
                         WGDP, 
                         VIX, 
                         PCOM, 
                         CR, 
                         EXR, 
                         INTR
                         )

per_up <- tidyr::gather(per_up, 
                        key = Variable, 
                        value = Up, 
                        GDP, 
                        CPI, 
                        WGDP, 
                        VIX, 
                        PCOM, 
                        CR, 
                        EXR, 
                        INTR
                        )

per <- per %>% 
       dplyr::bind_cols(per,
                         per_low,
                         per_up
                        ) %>% 
       dplyr::select(Horizon,
                      Variable,
                      Response,
                      Low,
                      Up
                     ) %>% 
       dplyr::mutate(Country = (rep("Peru",nrow(per))))

wgdp <- bind_rows(br, 
                  ch,
                  col,
                  per
                  )


wgdp <- wgdp %>% filter(Variable != "WGDP" & 
                          Variable != "VIX" & 
                          Variable != "PCOM"
                        ) %>% 
        mutate(Variable = replace(Variable, 
                                  Variable == "CR", "Country Risk"
                                  )
              ) %>% 
        mutate(Variable = replace(Variable, 
                                  Variable == "EXR", "Exchange Rate"
                                  )
               ) %>% 
        mutate(Variable = replace(Variable, 
                                  Variable == "INTR", "Interest Rate"
                                  )
               ) %>%
        mutate(Variable = factor(Variable, 
                                 levels = unique(Variable)
                                 )
               ) 

# Tick marks for the x-axis
xticks <- seq(min(0), 
              max(16), 
              by = 2
              )

# Change the directory to save the plot
setwd(here::here("IRFs"))

# WDEM SHOCK => This plot all countries at once 
wgdp %>% 
  ggplot(aes(x = Horizon, 
             y = Response
  )
  ) + 
  geom_line() +
  geom_line(aes(y = Low
  ), 
  linetype = "dotted"
  ) + 
  geom_line(aes(y = Up
  ), 
  linetype = "dotted"
  ) +
  scale_x_continuous("",
                     expand = c(0, 0), 
                     breaks = xticks
  ) +
  scale_y_continuous("",
                     breaks = scales::pretty_breaks(n = 6),
                     labels = scales::percent_format()
  ) + 
  geom_hline(yintercept = 0
  ) + 
  geom_ribbon(aes(ymin = Low, 
                  ymax = Up
  ), 
  fill = "grey", 
  alpha = 0.4
  ) + 
  theme_bw() + 
  geom_blank() + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5),
        strip.placement = "outside", 
        strip.background = element_blank(),
        strip.text.x = element_text(size=16), 
        strip.text.y = element_text(size=12), 
        axis.title.x = element_text(size=12)
  ) + 
  facet_grid(Variable ~ Country, 
             scales = "free", 
             switch="y"
  ) + 
  ggsave("wdem.pdf", 
         width = 40, 
         height = 20, 
         units = "cm"
  )

# Cleaning the workspace
rm(list = ls())  

# Going back to the code folder
setwd(here::here("IRFs",
                 "Code"
)
)

