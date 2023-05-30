PreAssembly <- function(i,
                        ParamList,
                        ParameterSource,
                        num_species = 150,
                        length_Relax= 50){
  
  
  cat(paste('\n Building: _',i,' of ' ,nrow(ParamList), '___ \n'))
  StartTIME<-Sys.time() 
  
  # loads baseline parameters that are constant across the simulations into sppPool list structure
  
  source(ParameterSource, local = TRUE) 
  
  params <- ParamList[i,]
  
  ## update variable simulation parameters. 
  sppPool$TempNoise<- params$TempNoise
  sppPool$mRate = params$mRate
  sppPool$EPC_MorseA = params$EPC_MorseA
  
  sppPool$g_seed <- parse_number(params$RunID)  # set seed based on ID number
  set.seed(sppPool$g_seed)
  
  #####  Generate networks:
  sppPool <- genNetwork(sppPool)   # Generate spatial network of nodes
  sppPool <- genDispMat(sppPool)   # Generate dispersal matrix between nodes
  sppPool$envMat <-   genTempGrad(sppPool)  #  generate temperature gradient
  
  sppPool$weather_record <- rnorm(500, mean = 0, sd = sppPool$TempNoise)  # generate a random sequence of temperature anomilies. 
  
  sppPool$CC_rate <- 0 # No CC yet
  
  ##############################
  ## 1. Assembly
  #########################
  
  ################################# 
  # 1.1 Community build up
  
  ## Initiate community with set number of species
  sppPool <-PopulateSystem(sppPool, num_species)
  
    cat('\nRelax: ')  

  ## allow to expand / relax
  for(sim_step in 1:length_Relax){  ## run simulation for a period to reach an approximate balance
    cat(sim_step)
    sppPool<- Run_Step(sppPool)
  }
  
  dir.create('Assemblies', showWarnings = FALSE)
  dir.create(paste0('Assemblies/' , params$TrialName), showWarnings = FALSE)
  
  save( sppPool,file =  paste0('Assemblies/' , params$TrialName, '/sppPool_', params$RunID))
  
  cat(paste0('time_taken:',Sys.time()-StartTIME ))
  
  return(1)
}
