get_shocks_irf <- function (df, m) {
  if (m == 0 | 
      m == 1 | 
      m == 2 | 
      m == 9
      ) {
    
    nvar <- 8
    
    list_df <- vector("list",
                      (nvar*3)
                      )
    
    shocks <- rep(c("Positive shock in WDEM",
                    "Negative shock in WUNC",
                    "Positive shock in WSUP",
                    "Positive shock in LUNC",
                    "FX",
                    "LDEM",
                    "LSUP",
                    "MP"
                    ),
                  nvar*3
                  )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
        
        list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
          dplyr::mutate(Shock = shocks[j])
      
    }
     
    labels <- c("Horizon",
                "WGDP",
                "VIX",
                "PCOM",
                "CR",
                "EXR",
                "GDP",
                "CPI",
                "INTR",
                "Shock"
                ) 
    
    for (k in 1:length(list_df)) {
      
      colnames(list_df[[k]]) <- labels
      
    }
    
    shocks_tidy <- lapply(list_df[1:nvar],
                          tidyr::gather,
                          key = Variable,
                          value = Response,
                          WGDP,
                          VIX,
                          PCOM,
                          CR,
                          EXR,
                          GDP,
                          CPI,
                          INTR
                          )
    
    low_tidy <- lapply(list_df[(nvar+1):(nvar*2)],
                       tidyr::gather,
                       key = Variable,
                       value = Low,
                       WGDP,
                       VIX,
                       PCOM,
                       CR,
                       EXR,
                       GDP,
                       CPI,
                       INTR
                       )
    
    up_tidy <- lapply(list_df[(nvar*2+1):(nvar*3)],
                      tidyr::gather,
                      key = Variable,
                      value = Up,
                      WGDP,
                      VIX,
                      PCOM,
                      CR,
                      EXR,
                      GDP,
                      CPI,
                      INTR
                      )
    
    tidy_df <- vector("list",
                      length(shocks_tidy)
                      )
    
    for (n in 1:length(shocks_tidy)) {
      
      tidy_df[[n]] <- dplyr::bind_cols(shocks_tidy[[n]],
                                       low_tidy[[n]],
                                       up_tidy[[n]]
                                       ) %>% 
        dplyr::select(Horizon,
                      Shock,
                      Variable,
                      Response,
                      Low,
                      Up
                      )
      
    }
    
    final_df <- dplyr::bind_rows(tidy_df) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  } else if (m == 3) {
    
    nvar <- 7
    
    list_df <- vector("list",
                      (nvar*3)
                      )
    
    shocks <- rep(c("Positive shock in WDEM",
                    "Positive shock in WSUP",
                    "Positive shock in LUNC",
                    "FX",
                    "LDEM",
                    "LSUP",
                    "MP"
                    ),
                  nvar*3
                  )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    labels <- c("Horizon",
                "WGDP",
                "PCOM",
                "CR",
                "EXR",
                "GDP",
                "CPI",
                "INTR",
                "Shock"
                ) 
    
    for (k in 1:length(list_df)) {
      
      colnames(list_df[[k]]) <- labels
      
    }
    
    shocks_tidy <- lapply(list_df[1:nvar],
                          tidyr::gather,
                          key = Variable,
                          value = Response,
                          WGDP,
                          PCOM,
                          CR,
                          EXR,
                          GDP,
                          CPI,
                          INTR
                          )
    
    low_tidy <- lapply(list_df[(nvar+1):(nvar*2)],
                       tidyr::gather,
                       key = Variable,
                       value = Low,
                       WGDP,
                       PCOM,
                       CR,
                       EXR,
                       GDP,
                       CPI,
                       INTR
                       )
    
    up_tidy <- lapply(list_df[(nvar*2+1):(nvar*3)],
                      tidyr::gather,
                      key = Variable,
                      value = Up,
                      WGDP,
                      PCOM,
                      CR,
                      EXR,
                      GDP,
                      CPI,
                      INTR
                      )
    
    tidy_df <- vector("list",
                      length(shocks_tidy)
                      )
    
    for (n in 1:length(shocks_tidy)) {
      
      tidy_df[[n]] <- dplyr::bind_cols(shocks_tidy[[n]],
                                       low_tidy[[n]],
                                       up_tidy[[n]]
                                       ) %>% 
        dplyr::select(Horizon,
                      Shock,
                      Variable,
                      Response,
                      Low,
                      Up
                      )
      
    }
    
    final_df <- dplyr::bind_rows(tidy_df) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  } else if (m == 4) {
    
    nvar <- 6
    
    list_df <- vector("list",
                      (nvar*3)
                      )
    
    shocks <- rep(c("Positive shock in WSUP",
                    "Positive shock in LUNC",
                    "FX",
                    "LDEM",
                    "LSUP",
                    "MP"
                    ),
                  nvar*3
                  )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    labels <- c("Horizon",
                "PCOM",
                "CR",
                "EXR",
                "GDP",
                "CPI",
                "INTR",
                "Shock"
                ) 
    
    for (k in 1:length(list_df)) {
      
      colnames(list_df[[k]]) <- labels
      
    }
    
    shocks_tidy <- lapply(list_df[1:nvar],
                          tidyr::gather,
                          key = Variable,
                          value = Response,
                          PCOM,
                          CR,
                          EXR,
                          GDP,
                          CPI,
                          INTR
                          )
    
    low_tidy <- lapply(list_df[(nvar+1):(nvar*2)],
                       tidyr::gather,
                       key = Variable,
                       value = Low,
                       PCOM,
                       CR,
                       EXR,
                       GDP,
                       CPI,
                       INTR
                       )
    
    up_tidy <- lapply(list_df[(nvar*2+1):(nvar*3)],
                      tidyr::gather,
                      key = Variable,
                      value = Up,
                      PCOM,
                      CR,
                      EXR,
                      GDP,
                      CPI,
                      INTR
                      )
    
    tidy_df <- vector("list",
                      length(shocks_tidy)
                      )
    
    for (n in 1:length(shocks_tidy)) {
      
      tidy_df[[n]] <- dplyr::bind_cols(shocks_tidy[[n]],
                                       low_tidy[[n]],
                                       up_tidy[[n]]
                                       ) %>% 
        dplyr::select(Horizon,
                      Shock,
                      Variable,
                      Response,
                      Low,
                      Up
                      )
      
    }
    
    final_df <- dplyr::bind_rows(tidy_df) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  } else if (m == 5) {
    
    nvar <- 7
    
    list_df <- vector("list",
                      (nvar*3)
                      )
    
    shocks <- rep(c("Positive shock in WDEM",
                    "Negative shock in WUNC",
                    "Positive shock in LUNC",
                    "FX",
                    "LDEM",
                    "LSUP",
                    "MP"
                    ),
                  nvar*3
                  )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    labels <- c("Horizon",
                "WGDP",
                "VIX",
                "CR",
                "EXR",
                "GDP",
                "CPI",
                "INTR",
                "Shock"
                ) 
    
    for (k in 1:length(list_df)) {
      
      colnames(list_df[[k]]) <- labels
      
    }
    
    shocks_tidy <- lapply(list_df[1:nvar],
                          tidyr::gather,
                          key = Variable,
                          value = Response,
                          WGDP,
                          VIX,
                          CR,
                          EXR,
                          GDP,
                          CPI,
                          INTR
                          )
    
    low_tidy <- lapply(list_df[(nvar+1):(nvar*2)],
                       tidyr::gather,
                       key = Variable,
                       value = Low,
                       WGDP,
                       VIX,
                       CR,
                       EXR,
                       GDP,
                       CPI,
                       INTR
                       )
    
    up_tidy <- lapply(list_df[(nvar*2+1):(nvar*3)],
                      tidyr::gather,
                      key = Variable,
                      value = Up,
                      WGDP,
                      VIX,
                      CR,
                      EXR,
                      GDP,
                      CPI,
                      INTR
                      )
    
    tidy_df <- vector("list",
                      length(shocks_tidy)
                      )
    
    for (n in 1:length(shocks_tidy)) {
      
      tidy_df[[n]] <- dplyr::bind_cols(shocks_tidy[[n]],
                                       low_tidy[[n]],
                                       up_tidy[[n]]
                                       ) %>% 
        dplyr::select(Horizon,
                      Shock,
                      Variable,
                      Response,
                      Low,
                      Up
                      )
      
    }
    
    final_df <- dplyr::bind_rows(tidy_df) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  } else if (m == 6) {
    
    nvar <- 7
    
    list_df <- vector("list",
                      (nvar*3)
                      )
    
    shocks <- rep(c("Negative shock in WUNC",
                    "Positive shock in WSUP",
                    "Positive shock in LUNC",
                    "FX",
                    "LDEM",
                    "LSUP",
                    "MP"
                    ),
                  nvar*3
                  )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    labels <- c("Horizon",
                "VIX",
                "PCOM",
                "CR",
                "EXR",
                "GDP",
                "CPI",
                "INTR",
                "Shock"
                ) 
    
    for (k in 1:length(list_df)) {
      
      colnames(list_df[[k]]) <- labels
      
    }
    
    shocks_tidy <- lapply(list_df[1:nvar],
                          tidyr::gather,
                          key = Variable,
                          value = Response,
                          VIX,
                          PCOM,
                          CR,
                          EXR,
                          GDP,
                          CPI,
                          INTR
                          )
    
    low_tidy <- lapply(list_df[(nvar+1):(nvar*2)],
                       tidyr::gather,
                       key = Variable,
                       value = Low,
                       VIX,
                       PCOM,
                       CR,
                       EXR,
                       GDP,
                       CPI,
                       INTR
                       )
    
    up_tidy <- lapply(list_df[(nvar*2+1):(nvar*3)],
                      gather,
                      key = Variable,
                      value = Up,
                      VIX,
                      PCOM,
                      CR,
                      EXR,
                      GDP,
                      CPI,
                      INTR
                      )
    
    tidy_df <- vector("list",
                      length(shocks_tidy)
                      )
    
    for (n in 1:length(shocks_tidy)) {
      
      tidy_df[[n]] <- dplyr::bind_cols(shocks_tidy[[n]],
                                       low_tidy[[n]],
                                       up_tidy[[n]]
                                       ) %>% 
        dplyr::select(Horizon,
                      Shock,
                      Variable,
                      Response,
                      Low,
                      Up
                      )
      
    }
    
    final_df <- dplyr::bind_rows(tidy_df) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  } else if (m == 7) {
    
    nvar <- 6
    
    list_df <- vector("list",
                      (nvar*3)
                      )
    
    shocks <- rep(c("Positive shock in WDEM",
                    "Positive shock in LUNC",
                    "FX",
                    "LDEM",
                    "LSUP",
                    "MP"
                    ),
                  nvar*3
                  )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    labels <- c("Horizon",
                "WGDP",
                "CR",
                "EXR",
                "GDP",
                "CPI",
                "INTR",
                "Shock"
                ) 
    
    for (k in 1:length(list_df)) {
      
      colnames(list_df[[k]]) <- labels
      
    }
    
    shocks_tidy <- lapply(list_df[1:nvar],
                          tidyr::gather,
                          key = Variable,
                          value = Response,
                          WGDP,
                          CR,
                          EXR,
                          GDP,
                          CPI,
                          INTR
                          )
    
    low_tidy <- lapply(list_df[(nvar+1):(nvar*2)],
                       tidyr::gather,
                       key = Variable,
                       value = Low,
                       WGDP,
                       CR,
                       EXR,
                       GDP,
                       CPI,
                       INTR
                       )
    
    up_tidy <- lapply(list_df[(nvar*2+1):(nvar*3)],
                      tidyr::gather,
                      key = Variable,
                      value = Up,
                      WGDP,
                      CR,
                      EXR,
                      GDP,
                      CPI,
                      INTR
                      )
    
    tidy_df <- vector("list",
                      length(shocks_tidy)
                      )
    
    for (n in 1:length(shocks_tidy)) {
      
      tidy_df[[n]] <- dplyr::bind_cols(shocks_tidy[[n]],
                                       low_tidy[[n]],
                                       up_tidy[[n]]
                                       ) %>% 
        dplyr::select(Horizon,
                      Shock,
                      Variable,
                      Response,
                      Low,
                      Up
                      )
      
    }
    
    final_df <- dplyr::bind_rows(tidy_df) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  } else if (m == 8) {
    
    nvar <- 6
    
    list_df <- vector("list",
                      (nvar*3)
                      )
    
    shocks <- rep(c("Negative shock in WUNC",
                    "Positive shock in LUNC",
                    "FX",
                    "LDEM",
                    "LSUP",
                    "MP"
                    ),
                  nvar*3
                  )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    labels <- c("Horizon",
                "VIX",
                "CR",
                "EXR",
                "GDP",
                "CPI",
                "INTR",
                "Shock"
                ) 
    
    for (k in 1:length(list_df)) {
      
      colnames(list_df[[k]]) <- labels
      
    }
    
    shocks_tidy <- lapply(list_df[1:nvar],
                          tidyr::gather,
                          key = Variable,
                          value = Response,
                          VIX,
                          CR,
                          EXR,
                          GDP,
                          CPI,
                          INTR
                          )
    
    low_tidy <- lapply(list_df[(nvar+1):(nvar*2)],
                       tidyr::gather,
                       key = Variable,
                       value = Low,
                       VIX,
                       CR,
                       EXR,
                       GDP,
                       CPI,
                       INTR
                       )
    
    up_tidy <- lapply(list_df[(nvar*2+1):(nvar*3)],
                      tidyr::gather,
                      key = Variable,
                      value = Up,
                      VIX,
                      CR,
                      EXR,
                      GDP,
                      CPI,
                      INTR
                      )
    
    tidy_df <- vector("list",
                      length(shocks_tidy)
                      )
    
    for (n in 1:length(shocks_tidy)) {
      
      tidy_df[[n]] <- dplyr::bind_cols(shocks_tidy[[n]],
                                       low_tidy[[n]],
                                       up_tidy[[n]]
                                       ) %>%
        dplyr::select(Horizon,
                      Shock,
                      Variable,
                      Response,
                      Low,
                      Up
                      )
      
    }
    
    final_df <- dplyr::bind_rows(tidy_df) %>%
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  }
    
    
}