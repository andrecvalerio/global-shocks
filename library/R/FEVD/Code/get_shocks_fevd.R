get_shocks_fevd <- function(df, m) {
  if (m == 1 
      | m == 2 
      | m == 9 
      | m == 0 
      ){
    
    nvar <- 8
    
    list_df <- vector("list", 
                      nvar
                      )
    
    shocks <- c("WDEM",
                "WUNC",
                "WSUP",
                "LUNC",
                "FX",
                "LDEM",
                "LSUP",
                "MP"
                )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    label <- c("Horizon",
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
      
      colnames(list_df[[k]]) <- label
      
    }
    
    shocks_tidy <- lapply(list_df, 
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
    
    x <- dplyr::bind_rows(shocks_tidy) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  } else if (m == 3){
    
    nvar <- 7
    
    list_df <- vector("list", 
                      nvar
                      )
    
    shocks <- c("WDEM",
                "WSUP",
                "LUNC",
                "FX",
                "LDEM",
                "LSUP",
                "MP"
                )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    label <- c("Horizon",
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
      
      colnames(list_df[[k]]) <- label
      
    }
    
    shocks_tidy <- lapply(list_df, 
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
    
    x <- dplyr::bind_rows(shocks_tidy) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  } else if (m == 4){
    
    nvar <- 6
    
    list_df <- vector("list", 
                      nvar
                      )
    
    shocks <- c("WSUP",
                "LUNC",
                "FX",
                "LDEM",
                "LSUP",
                "MP"
                )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    label <- c("Horizon",
               "PCOM",
               "CR",
               "EXR",
               "GDP",
               "CPI",
               "INTR",
               "Shock"
               )
    
    for (k in 1:length(list_df)) {
      
      colnames(list_df[[k]]) <- label
      
    }
    
    shocks_tidy <- lapply(list_df, 
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
    
    x <- dplyr::bind_rows(shocks_tidy) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  } else if (m == 5) {
    
    nvar <- 7
    
    list_df <- vector("list", 
                      nvar
                      )
    
    shocks <- c("WDEM",
                "WUNC",
                "LUNC",
                "FX",
                "LDEM",
                "LSUP",
                "MP"
                )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    label <- c("Horizon",
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
      
      colnames(list_df[[k]]) <- label
      
    }
    
    shocks_tidy <- lapply(list_df, 
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
    
    x <- dplyr::bind_rows(shocks_tidy) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  } else if (m == 6) {
    
    nvar <- 7
    
    list_df <- vector("list", 
                      nvar
                      )
    
    shocks <- c("WUNC",
                "WSUP",
                "LUNC",
                "FX",
                "LDEM",
                "LSUP",
                "MP"
                )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    label <- c("Horizon",
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
      
      colnames(list_df[[k]]) <- label
      
    }
    
    shocks_tidy <- lapply(list_df, 
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
    
    x <- dplyr::bind_rows(shocks_tidy) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  } else if (m == 7){
    
    nvar <- 6
    
    list_df <- vector("list", 
                      nvar
                      )
    
    shocks <- c("WDEM",
                "LUNC",
                "FX",
                "LDEM",
                "LSUP",
                "MP"
                )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    label <- c("Horizon",
               "WGDP",
               "CR",
               "EXR",
               "GDP",
               "CPI",
               "INTR",
               "Shock"
               )
    
    for (k in 1:length(list_df)) {
      
      colnames(list_df[[k]]) <- label
      
    }
    
    shocks_tidy <- lapply(list_df, 
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
    
    x <- dplyr::bind_rows(shocks_tidy) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
    
  } else if (m == 8){
    
    nvar <- 6
    
    list_df <- vector("list",
                      nvar
                      )
    
    shocks <- c("WUNC",
                "LUNC",
                "FX",
                "LDEM",
                "LSUP",
                "MP"
                )
    
    list_df[[1]] <- df[,1:(nvar+1)] %>% 
      dplyr::mutate(Shock = shocks[1])
    
    for (j in 2:length(list_df)) {
      
      list_df[[j]] <- df[,c(1,((j-1)*nvar+2):(j*nvar+1))] %>% 
        dplyr::mutate(Shock = shocks[j])
      
    }
    
    label <- c("Horizon",
               "VIX",
               "CR",
               "EXR",
               "GDP",
               "CPI",
               "INTR",
               "Shock"
               )
    
    for (k in 1:length(list_df)) {
      
      colnames(list_df[[k]]) <- label
      
    }
    
    shocks_tidy <- lapply(list_df, 
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
    
    x <- dplyr::bind_rows(shocks_tidy) %>% 
      dplyr::mutate(Model = paste0("Model ",
                                   m
                                   )
                    )
  
  }
  
}