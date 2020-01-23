# Set path to where the excel sheets are stored
setwd(here::here("IRFs",
                 "Data",
                 "VIX"
                 )
      )

# Loading the dataset for the VIX shock
vix_sheets <- list.files(pattern = '*vix.xls')
vix_irf <- lapply(vix_sheets, 
                  readxl::read_excel, 
                  sheet = 2
                  )

# Individualizing the datasets
br_low  <- vix_irf[[1]]
br_up   <- vix_irf[[2]]
br      <- vix_irf[[3]]
ch_low  <- vix_irf[[4]]
ch_up   <- vix_irf[[5]]
ch      <- vix_irf[[6]]
col_low <- vix_irf[[7]]
col_up  <- vix_irf[[8]]
col     <- vix_irf[[9]]
per_low <- vix_irf[[10]]
per_up  <- vix_irf[[11]]
per     <- vix_irf[[12]]

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
                   ch_up
                   ) %>% 
  dplyr::select(Horizon,
                Variable,
                Response,
                Low,
                Up
                ) %>% 
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

vix <- dplyr::bind_rows(br,
                        ch,
                        col,
                        per
                        )


vix <- vix %>% dplyr::filter(Variable != "WGDP" & 
                              Variable != "VIX" & 
                              Variable != "PCOM"
                            ) %>% 
  dplyr::mutate(Variable = replace(Variable, 
                                   Variable == "CR", "Country Risk"
                                   )
                ) %>% 
  dplyr::mutate(Variable = replace(Variable, 
                                   Variable == "EXR", "Exchange Rate"
                                   )
                ) %>% 
  dplyr::mutate(Variable = replace(Variable, 
                                   Variable == "INTR", "Interest Rate"
                                   )
                ) %>% 
  dplyr::mutate(Variable = factor(Variable, 
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
vix %>% 
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
  ggsave("wunc.pdf", 
         width = 40, 
         height = 20, 
         units = "cm"
  )

# Cleaning the workspace
rm(list = ls())  

# Going back to the main folder
setwd(here::here("IRFs",
                 "Code"
)
)