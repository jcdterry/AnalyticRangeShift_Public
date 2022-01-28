Lag_Measurer <- function(i,
                             ParamList,
                             ParameterSource = 'Parameters/Parameters_Simple.R',
                             length_assembly = 150,
                             length_Relax= 50,
                             length_preCC=50,
                             length_CC_preTest = 20,
                             length_CC=30,
                             CC_rate= 0.1,
                             PreBuilt=TRUE){
  
  
  cat(paste('\n \n Testing: __',i,' of ' ,nrow(ParamList), '___'))
  StartTIME<-Sys.time() 
  
  # if(!PreBuilt){ # If need to build, build.  (normally this would be predone)
  #   PreAssembly(i, ParamList, ParameterSource, length_assembly, length_Relax)
  # }
  
  
  params <- ParamList[i,]
  
  ## Load spoPool from previously saved assembly
  load(paste0('Assemblies/' , params$TrialName, '/sppPool_', params$RunID))
  
    set.seed(i)

  ##########################
  ## 1. Preparatory Steps
  
  #### Create tidy node list to use later
  sppPool$network %>%
    as.data.frame() %>%
    mutate( Node = paste0('V', 1: sppPool$topo$no_nodes))%>%
    rename(X=V1, Y=V2)-> NodeList
  
  ########################
  ## 1.2 Assaying pre-CC range limits and average biomasses through time
  
    ToTrack = sppPool$p_IDs
  TrackIndex <-  1:length(ToTrack)
  ThermalOptimum =sppPool$tVec
  
  PreOutsList <- list()
  
  cat('\nPre-CC: ')
  
  for(PreCC_step in 1:length_preCC){
    cat(PreCC_step)

        sppPool<-Run_Step(sppPool)
    
    Sp_StillPresent <-  ToTrack[ToTrack %in% sppPool$p_IDs]
    
    #### Identify range limits of focal species
    
    sppPool$bMat_p %>%
      as.data.frame %>%
      mutate(Species = sppPool$p_IDs) %>%
      filter( Species %in%Sp_StillPresent ) %>%
      gather('Node', 'Biomass',  - Species)  %>%
      filter( Biomass > sppPool$thresh)%>%        # for  range limits, (those below thresh have minimal influence mid point)
      left_join(NodeList, by = "Node") %>%
      group_by(Species) %>%
      summarise(Range_Front = min(X),
                Range_Rear = max(X),
                Range_Mid =  weighted.mean(X,Biomass),
                TotalBiomass = sum(Biomass ),
                .groups = 'keep' ) %>% ## just to keep it quiet
      mutate( PreCC_step = PreCC_step,
              Weather = sppPool$weather_record[sppPool$SimIter]) -> PreOuts
    
    PreOutsList[[PreCC_step]]<- PreOuts
  } 
  
  PreOuts_DF<- map_df(PreOutsList, ~.x)
  
  
  #####################################
  ## 2. CC period
  ##################################
  
  ## Thresholding is effectively switched off for this part - species won't go fully extinct, and can be tracked all the way down
  
  sppPool$thresh <- 0
  
  ###################
  ## 2.1 Run a short amount of CC to overcome initial 'stickyness'
  
  ## Some species will drop out and go extinct in this initial period. 
  
  sppPool$CC_start <- sppPool$SimIter+1 # start CC in the next step
  sppPool$CC_rate <- CC_rate # temperature increase per 'year'
  
  cat('\nCC: ')
  
  ##    sppPool$bMat_p[1,] %>% plot

  for(CC_step in 1:length_CC_preTest){
    cat(CC_step)
    sppPool<-Run_Step(sppPool)
    
  ##  sppPool$bMat_p[1,] %>% points(col = rainbow(length_CC_preTest)[CC_step])
    
  } 
  
  ### Save a copy of system state 
  StartCC_sppPool <- sppPool
  
  ########################
  ## 2.2 Main CC testing
  
  ### Run CC, tracking mid points and biomasss along the way every year
  
  CCOutsList <- list()
  
  cat('\nTesting: ')
  
  for(CC_step in 1:length_CC){
    cat(CC_step)
    sppPool<-Run_Step(sppPool)
    
    ### Tracking
    Sp_StillPresent <-  ToTrack[ToTrack %in% sppPool$p_IDs]
    
    #### Identify range limits of focal species
    
    sppPool$bMat_p %>%
      as.data.frame %>%
      mutate(Species = sppPool$p_IDs) %>%
      filter( Species %in%Sp_StillPresent ) %>%
      gather('Node', 'Biomass',  - Species)  %>%
      filter( Biomass > sppPool$thresh)%>%          
      left_join(NodeList, by = "Node") %>%
      group_by(Species) %>%
      summarise(Range_Mid =  weighted.mean(X,Biomass),
                TotalBiomass = sum(Biomass),
                .groups = 'keep' ) %>% ## just to keep it quiet
      mutate( totCC_step = CC_step+length_CC_preTest,
              Weather = sppPool$weather_record[sppPool$SimIter]) -> CCOuts
    
    CCOutsList[[CC_step]]<- CCOuts
  } 
  
  CCOuts_DF<- map_df(CCOutsList, ~.x)
  
  ################
  ## 3. Post-Calculations
  
  #############################
  ### 3.1 Calculating Lags
  
  DegreesPerX_unit = diff(sppPool$topo$T_range) / sppPool$topo$X_length
  
  PreOuts_DF %>%
    summarise(InitialXRange = mean(Range_Rear-Range_Front),
              InitialMid = mean(Range_Mid  ),
              .groups = 'keep' ) -> InitialMids
  
  CCOuts_DF %>%
    left_join(InitialMids, by = "Species") %>%
    mutate( Total_CC_To_Time =  totCC_step*sppPool$CC_rate ,
            Expected_X_Move = Total_CC_To_Time / DegreesPerX_unit,
            Observed_X_Move = -(Range_Mid   - InitialMid ),        ### NB flipping sign here, + = direction of CC
            Lag =  Expected_X_Move-Observed_X_Move) -> LagOuts_DF2
  
  LagOuts_DF2 %>% 
    summarise(SpInitalMeanRange =  mean( InitialXRange ), 
              SpMeanLag = mean( Lag) ,
              .groups = 'keep') -> SpeciesLags
  

  #####################################
  ## Collecting for Final Output
  ##########################################
  
  data.frame(Species =  ToTrack,
             RunID = params$RunID,
             TrialName = params$TrialName,
             ThermalOptimum=ThermalOptimum) %>%
    left_join(SpeciesLags, by = "Species" )  -> TotalOutput
  
  cat(paste0('\ntime_taken:',signif(Sys.time()-StartTIME ),4))
  
  return(TotalOutput)
}

