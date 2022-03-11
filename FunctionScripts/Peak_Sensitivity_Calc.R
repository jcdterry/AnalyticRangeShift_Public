Peak_Sensitivity_Calc <- function(i,
                                  ParamList,
                                  length_CC=50,
                                  Locs_to_test,   # vector of location values to test
                                  Width ,    # width of bump
                                  Add_Gain, # value added to growth rates 
                                  CC_rate  ){
  
  ## Function tests the number of extinct species at each location of climate change

  cat(paste('\n Testing: _',i,' of ' ,nrow(ParamList), '___ \n'))
  StartTIME<-Sys.time() 
  
  params <- ParamList[i,]
  
  ## Load sppPool from previously saved assembly
  load(paste0('Assemblies/' , params$TrialName, '/sppPool_', params$RunID))
  set.seed(i)
  
  ###########################
  ## 1. Select species to track 
  
  ToTrack <- sppPool$p_IDs
  
  #####################################
  ## 2. CC period
  ##################################
  ## Thresholding is effectively switched off for this part - species won't go fully extinct, and can be tracked all the way down
  
  sppPool$thresh <- 0
  sppPool$CC_start <- sppPool$SimIter+1 # start CC in the next step
  sppPool$CC_rate <- CC_rate
  StartCC_sppPool <- sppPool  ### Save a copy of system state 
  
  CC_outputs <- data.frame( Locations = Locs_to_test,
                            NumberFocalStart = length(ToTrack ),
                            Trial = params$TrialName,
                            RunID = params$RunID,
                            NumberNowExtant_1=NA)
  
  ################
  ### 3. Run test with no conservation intervention as a baseline
  cat('Running Baseline')
  for(CC_step in 1:length_CC){
    cat('.')
    #### opening up 'Run_Step()' function to allow conservation intervention
    sppPool$SimIter = sppPool$SimIter +1
    sppPool<-RecalculateGrowthWithNewTemps(sppPool)
    Endpoint_biomasses<-  metaCDynamics_lite(relaxT = sppPool$tMax,
                                             sppPool = sppPool)$P_array
    sppPool <-   clean_extinct(sppPool, Endpoint_biomasses)$sppPool   
  }
  Trackedindicies <-  which( sppPool$p_IDs %in% ToTrack)
  EndBiomassesFocal <- sppPool$bMat_p[Trackedindicies,]
  CC_outputs$NumExtant_no_intervention <-  sum(rowSums(EndBiomassesFocal>1 , na.rm = TRUE) !=0)
  
  #########################
  ## 4. repeat with different locations for intervention
  
  for( Location_i in 1:length(Locs_to_test)){
    Location <- Locs_to_test[Location_i]
    cat(paste0('\nLocation: ',  Location_i  ))
    sppPool <-   StartCC_sppPool 
    
    for(CC_step in 1:length_CC){
      cat('.')
      #### opening up 'Run_Step()' function to allow conservation intervention
      sppPool$SimIter = sppPool$SimIter +1
      sppPool<-RecalculateGrowthWithNewTemps(sppPool)
      
      #   plot( sppPool$rMat[1,], main = CC_step, ylim = c(-1,10), type = 'l')
      
      sppPool$rMat <- ConservationAction( RMat=sppPool$rMat, 
                                          envMat = sppPool$envMat , 
                                          CC=(sppPool$CC_rate*(sppPool$SimIter -sppPool$CC_start)) , 
                                          tVec = sppPool$tVec, Location = Location, 
                                          Width = Width, Add_Gain  =Add_Gain) 
      #      points( sppPool$rMat[1,], col = 2, type = 'l')
      
      Endpoint_biomasses<-  metaCDynamics_lite(relaxT = sppPool$tMax,
                                               sppPool = sppPool)$P_array
      sppPool <-   clean_extinct(sppPool, Endpoint_biomasses)$sppPool   
    }
    ## find indices
    Trackedindicies <-  which( sppPool$p_IDs %in% ToTrack)
    EndBiomassesFocal <- sppPool$bMat_p[Trackedindicies,]
    CC_outputs$NumberNowExtant_1[Location_i]    <-  sum(rowSums(EndBiomassesFocal>1 , na.rm = TRUE) !=0)
  }
  
  cat(paste0('time_taken:',Sys.time()-StartTIME ))
  return(CC_outputs)
}