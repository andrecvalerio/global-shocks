# Set path to where excel sheets are stored
setwd(here::here("IRFs",
                 "Data",
                 "INTL"
                 )
      )

# Loading the dataset
sheets <- list.files(pattern = '*.xls')
irfs   <- lapply(sheets, 
                 readxl::read_excel,
                 sheet = 2
                 )

# Individualizing the datasets
w_low  <- irfs[[3]]
w_up   <- irfs[[7]]
w      <- irfs[[9]]

v_low  <- irfs[[2]]
v_up   <- irfs[[6]]
v      <- irfs[[8]]

p_low  <- irfs[[1]]
p_up   <- irfs[[5]]
p      <- irfs[[4]]

w <- tidyr::gather(w, 
                   key = Variable,
                   value = Response, 
                           GDP, 
                           CPI, 
                           WGDP, 
                           PCOM, 
                           VIX, 
                           CR, 
                           EXR, 
                           INTR
                   )

w_low <- tidyr::gather(w_low, 
                       key = Variable,
                       value = Low, 
                               GDP, 
                               CPI, 
                               WGDP, 
                               PCOM, 
                               VIX, 
                               CR, 
                               EXR, 
                               INTR
                       )

w_up <- tidyr::gather(w_up, 
                      key = Variable, 
                      value = Up, 
                              GDP, 
                              CPI, 
                              WGDP, 
                              PCOM, 
                              VIX, 
                              CR, 
                              EXR, 
                              INTR
                      )

w <- w %>% 
  dplyr::bind_cols(w,
                   w_low,
                   w_up
                   ) %>% 
  dplyr::select(Horizon,
                Variable,
                Response,
                Low,
                Up
                ) %>% 
  dplyr::mutate(Shock = (rep("Positive shock in WDEM",
                             nrow(w)
                             )
                         )
                ) 

v <- tidyr::gather(v, 
            key = Variable, 
            value = Response, 
                    GDP, 
                    CPI, 
                    WGDP, 
                    PCOM, 
                    VIX, 
                    CR, 
                    EXR, 
                    INTR
            )

v_low <- tidyr::gather(v_low, 
                       key = Variable, 
                       value = Low, 
                               GDP, 
                               CPI, 
                               WGDP, 
                               PCOM, 
                               VIX, 
                               CR, 
                               EXR, 
                               INTR
                       )

v_up <- tidyr::gather(v_up, 
                      key = Variable, 
                      value = Up, 
                              GDP, 
                              CPI, 
                              WGDP, 
                              PCOM, 
                              VIX, 
                              CR, 
                              EXR, 
                              INTR
                      )

v <- v %>% 
  dplyr::bind_cols(v,
                   v_low,
                   v_up
                   ) %>% 
  dplyr::select(Horizon,
                Variable,
                Response,
                Low,
                Up
                ) %>% 
  dplyr::mutate(Shock = (rep("Negative shock in WUNC",
                             nrow(v)
                             )
                         )
                )

p <- tidyr::gather(p, 
                   key = Variable, 
                   value = Response, 
                           GDP, 
                           CPI, 
                           WGDP, 
                           PCOM, 
                           VIX, 
                           CR, 
                           EXR, 
                           INTR
                   )

p_low <- tidyr::gather(p_low, 
                       key = Variable, 
                       value = Low, 
                               GDP, 
                               CPI, 
                               WGDP, 
                               PCOM, 
                               VIX, 
                               CR, 
                               EXR, 
                               INTR
                       )

p_up <- tidyr::gather(p_up, 
                      key = Variable, 
                      value = Up, 
                              GDP, 
                              CPI, 
                              WGDP, 
                              PCOM, 
                              VIX, 
                              CR, 
                              EXR, 
                              INTR
                      )

p <- p %>% 
  dplyr::bind_cols(p,
                   p_low,
                   p_up
                   ) %>% 
  dplyr::select(Horizon,
                Variable,
                Response,
                Low,
                Up
                ) %>% 
  dplyr::mutate(Shock = (rep("Positive shock in WSUP",
                             nrow(p)
                             )
                         )
                )

intl <- dplyr::bind_rows(w,
                         v,
                         p
                         )

intl <- intl %>% 
  dplyr::filter(Variable == "WGDP" | 
                  Variable == "VIX" | 
                  Variable == "PCOM"
                ) %>% 
  dplyr::mutate(Variable = recode(Variable, 
                                  "WGDP" = "WDEM", 
                                  "VIX" = "WUNC", 
                                  "PCOM" = "WSUP"
                                  ),
                Variable = factor(Variable, 
                                  levels = c("WDEM", 
                                             "WUNC", 
                                             "WSUP"
                                             )
                                  ),
                Shock    = factor(Shock, 
                                  levels = unique(Shock)
                                  )
                ) 

# Tick marks for the x-axis
xticks <- seq(min(0), 
              max(16), 
              by = 2
              )

# First I create a plot for each shock
dem <- intl %>% 
  dplyr::filter(Shock == "Positive shock in WDEM") %>% 
  ggplot2::ggplot(aes(x = Horizon, 
                     y = Response
                     )
                 ) + 
  geom_line() +
  geom_line(aes(y = Low), 
            linetype = "dotted"
            ) +
  geom_line(aes(y = Up), 
            linetype = "dotted"
            ) +
  facet_grid(vars(Variable),
             scales = "free",
             space = "fixed",
             switch = "y"
             ) +
  scale_x_continuous("",
                     expand = c(0, 0), 
                     breaks = xticks
                     ) +
  scale_y_continuous("",
                     breaks = scales::pretty_breaks(n = 7),
                     labels = scales::percent_format()
                     ) + 
  geom_hline(yintercept = 0) + 
  geom_ribbon(aes(ymin = Low, 
                  ymax = Up
                  ), 
              fill = "grey", 
              alpha = 0.4
              ) +
  ggtitle("Positive shock in WDEM") +
  theme_bw() + 
  geom_blank() + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5),
        strip.placement = "outside", 
        strip.background = element_blank(),
        strip.text.x = element_text(size=16), 
        strip.text.y = element_text(size=12)
        )

unc <- intl %>% 
  dplyr::filter(Shock == "Negative shock in WUNC") %>% 
  ggplot(aes(x = Horizon, 
             y = Response
             )
         ) + 
  geom_line() +
  geom_line(aes(y = Low), 
            linetype = "dotted"
            ) +
  geom_line(aes(y = Up), 
            linetype = "dotted"
            ) +
  facet_grid(vars(Variable),
             scales = "free",
             space = "fixed",
             switch = "y"
            ) +
  scale_x_continuous("",
                     expand = c(0, 0), 
                     breaks = xticks
                     ) +
  scale_y_continuous("",
                     breaks = scales::pretty_breaks(n = 7),
                     labels = scales::percent_format()
                     ) + 
  geom_hline(yintercept = 0) + 
  geom_ribbon(aes(ymin = Low, 
                  ymax = Up
                  ), 
              fill = "grey", 
              alpha = 0.4
              ) +
  ggtitle("Negative shock in WUNC") +
  theme_bw() + 
  geom_blank() + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5),
        strip.placement = "outside", 
        strip.background = element_blank(),
        strip.text = element_blank()
        )

sup <- intl %>% 
  dplyr::filter(Shock == "Positive shock in WSUP") %>% 
  ggplot(aes(x = Horizon, 
             y = Response
             )
         ) + 
  geom_line() +
  geom_line(aes(y = Low), 
            linetype = "dotted"
            ) +
  geom_line(aes(y = Up), 
            linetype = "dotted"
            ) +
  scale_x_continuous("",
                     expand = c(0, 0), 
                     breaks = xticks
                     ) +
  scale_y_continuous("",
                     breaks = scales::pretty_breaks(n = 7),
                     labels = scales::percent_format()
                     ) + 
  facet_grid(vars(Variable),
             scales = "free",
             space = "fixed",
             switch = "y"
            ) +
  geom_hline(yintercept = 0) + 
  geom_ribbon(aes(ymin = Low, 
                  ymax = Up
                  ), 
              fill = "grey", 
              alpha = 0.4
              ) +
  ggtitle("Positive shock in WSUP") +
  theme_bw() + 
  geom_blank() + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5),
        strip.placement = "outside", 
        strip.background = element_blank(),
        strip.text = element_blank()
  )

# Then I group them together
intl_irf <- ggpubr::ggarrange(dem,
                              unc,
                              sup,
                              ncol = 3
                              )

# And save
setwd(here::here("IRFs"))
ggplot2::ggsave("intl.pdf",
                plot = intl_irf, 
                width = 40, 
                height = 20, 
                units = "cm"
                )

# Clean workspace
rm(list = ls())

# Going back to the code folder
setwd(here::here("IRFs",
                 "Code"
)
)


# This code is more elegant but I do not like the resulting plot because the y-axis is fixed for every row
# And this compress the graph for some of the panels. 
# intl %>% ggplot(aes(x = Horizon, y = Response)) + geom_line() +
#   geom_line(aes(y = Low), linetype = "dotted") + 
#   geom_line(aes(y = Up), linetype = "dotted") +
#   facet_grid(Variable ~ Shock, 
#              scales = "free_y", 
#              space = "fixed", 
#              switch="y") +
#   scale_x_continuous("",
#                      expand = c(0, 0), 
#                      breaks = xticks) +
#   scale_y_continuous("",
#                      breaks = scales::pretty_breaks(n = 8)) + 
#   geom_hline(yintercept = 0) + 
#   geom_ribbon(aes(ymin = Low, ymax = Up), 
#               fill = "grey", 
#               alpha = 0.4) + 
#   theme_bw() + geom_blank() + 
#   theme(panel.grid.major = element_blank(), 
#         panel.grid.minor = element_blank(),
#         plot.title = element_text(hjust = 0.5),
#         strip.placement = "outside", 
#         strip.background = element_blank(),
#         strip.text.x = element_text(size=16), 
#         strip.text.y = element_text(size=12)) +
#   ggsave("intl6.pdf", width = 40, height = 20, units = "cm")


