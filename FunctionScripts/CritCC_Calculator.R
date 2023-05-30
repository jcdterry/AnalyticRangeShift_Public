CritCC_Calculator <- function(i,
                              ParamList,
                              length_CC=50,
                              CC_rates= seq(0,0.4, l = 4) ){ # nb rate of 0.4 = 20 degrees shift, nearing edge. 

    ## Function tests the number of extinct species at each level of climate change

  cat(paste('\n Testing: _',i,' of ' ,nrow(ParamList), '___ \n'))
  StartTIME<-Sys.time() 

  params <- ParamList[i,]
  
  ## Load spoPool from previously saved assembly
  load(paste0('Assemblies/' , params$TrialName, '/sppPool_', params$RunID))
    set.seed(i)

  ###########################
  ## 1. Select species to track (here, all of them)
    ToTrack <- sppPool$p_IDs
    
  #####################################
  ## 2. CC period
  ##################################
  ## Thresholding is effectively switched off for this part - species won't go fully extinct, and can be tracked all the way down

  sppPool$thresh <- 0
  sppPool$CC_start <- sppPool$SimIter+1 # start CC in the next step
  StartCC_sppPool <- sppPool  ### Save a copy of system state 
  
  CC_outputs <- data.frame( CC_rate = CC_rates,
                            NumberFocalStart = length(ToTrack ),
                            Trial = params$TrialName,
                            RunID = params$RunID,
                            NumberNowExtant_0.01=NA,
                            NumberNowExtant_1=NA)
  
  for( CC_rate_i in 1:length(CC_rates)){ ## Cycle through different climate change rates
    cat(paste0('\nCC rate: ',  CC_rates[CC_rate_i]  ))
    
    sppPool <-   StartCC_sppPool   ## reset the simulation to the starting assembly
    sppPool$CC_rate <- CC_rates[CC_rate_i] ## set the CC rate
    
    for(CC_step in 1:length_CC){  ## step through the timesteps as climate change progresses
      cat('.')
      sppPool<-Run_Step(sppPool)  ## run the simulation one timestep
    }
    ## find indices
   Trackedindicies <-  which( sppPool$p_IDs %in% ToTrack)
    
    EndBiomassesFocal <- sppPool$bMat_p[Trackedindicies,]

    CC_outputs$NumberNowExtant_0.0001[CC_rate_i] <-  sum(rowSums(EndBiomassesFocal>0.0001 , na.rm = TRUE) !=0)
    CC_outputs$NumberNowExtant_0.01[CC_rate_i] <-  sum(rowSums(EndBiomassesFocal>0.01 , na.rm = TRUE) !=0)
    CC_outputs$NumberNowExtant_1[CC_rate_i]    <-  sum(rowSums(EndBiomassesFocal>1 , na.rm = TRUE) !=0)
}
  
  cat(paste0('time_taken:',Sys.time()-StartTIME ))
  return(CC_outputs)
}
