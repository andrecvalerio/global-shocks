plot_irf <- function(var,m, shock, intl = 0, cf = 0) {
  
  # X axis tick marks
  xticks <- seq(min(0),max(16),by = 2)
  
  if (intl != 0) {
    
    irfs %>% dplyr::filter(Model == m) %>% 
      dplyr::filter(Variable == "World GDP" |
                      Variable == "VIX" |
                      Variable == "Commodity Prices"
      ) %>% 
      dplyr::filter(Country == "Brazil") %>% 
      dplyr::filter(Shock == "Positive shock in WDEM" |
                      Shock == "Negative shock in WUNC" |
                      Shock == "Positive shock in WSUP"
      ) %>% 
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
      facet_grid(Variable ~ Shock,
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
            axis.text.y.right = element_blank(),
            axis.ticks.y.right = element_blank(),
            axis.title.y.left = element_blank(),
            axis.title.y.right = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_text(margin(0,20,0,0))
      ) +
      ggsave(paste("intl_m",
                   substr(m,
                          7,
                          7
                   ),
                   ".pdf",
                   sep=""
      ),
      width = 40, 
      height = 20,  
      units = "cm"
      )
    
  } else if (cf != 0) {
    
    irfs %>% dplyr::filter(Model == "Model 1" |
                             Model == "Model 0") %>% 
      dplyr::mutate(Model = recode(Model,
                                   "Model 1" = "Benchmark",
                                   "Model 0" = "Counterfactual"
                                   )
                    ) %>% 
      dplyr::filter(Variable == var & 
                      Variable != "Country Risk"
                    ) %>% 
      dplyr::filter(Shock == shock) %>% 
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
                         breaks = scales::pretty_breaks(n = 5),
                         labels = if (var == "Interest Rate") function(x) paste0(round(x*100,3), "pp") else scales::percent_format(),
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
            strip.text.x = if (var != "GDP") element_blank() else element_text(size=16),
            strip.text.y = element_text(size=12),
            axis.text.y.right = element_blank(),
            axis.ticks.y.right = element_blank(),
            axis.ticks.x = if (var != "Interest Rate") element_blank(),
            axis.text.x = if (var != "Interest Rate") element_blank(),
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
                         )
  } else {
    
    irfs %>% dplyr::filter(Model == m) %>% 
      dplyr::filter(Variable == var) %>% 
      dplyr::filter(Shock == shock) %>% 
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
      facet_grid(Variable ~ Country,
                 scales = "free",
                 space = "fixed"
      ) +
      scale_x_continuous("",
                         expand = c(0, 0), 
                         breaks = xticks
      ) +
      scale_y_continuous("",
                         breaks = scales::pretty_breaks(n = 5),
                         labels = if (var == "Interest Rate") function(x) paste0(round(x*100,3), "pp") else scales::percent_format(),
                         position = "right",
                         sec.axis = dup_axis()
      ) + 
      geom_hline(yintercept = 0) + 
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
            strip.text.x = if (var != "GDP") element_blank() else element_text(size=16),
            strip.text.y = element_text(size=12),
            axis.text.y.right = element_blank(),
            axis.ticks.y.right = element_blank(),
            axis.ticks.x = if (var != "Interest Rate") element_blank(),
            axis.text.x = if (var != "Interest Rate") element_blank(),
            axis.title.y.left = element_blank(),
            axis.title.y.right = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_text(margin(0,20,0,0))
      ) 
    
  }
  
}