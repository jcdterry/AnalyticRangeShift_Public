no_nodes = 200


sppPool<- list(
  ## Run Parameters
  min_b =  1e-7,      # minimum biomass increase after invasion for inclusion in model 
  tMax = 15,     ## How many time steps per 'year'
  inv = 1e-6,  # biomass at which new invaders start in their favoured location
  thresh = 1e-6,   ## Lower threshold to assume persistence. 
  timescale = 0.05, ## Scaling factor for all dynamics. Scales all rates of change, for easier smoothing of discrete jumping. Smaller values slows down change. 
  g_seed=10, # random seed
  AddInvaders= TRUE  , # whether to add invaders each time step 
  verbose = FALSE, ## Chatty output. largely for debugging
  
  # Ecological Parameters
  
  ###  Environment and Performance Curve
  R_Max = 12, # maximum growth rate at peak environment (nb before mortality)
  mort = 3, # mortality = loss rate in totally unsuitable environment
  OptRange = c(20, 30), ## Rage from which to draw species to introduce (that will become the focal species)   
  
  ## Harmonic and Morse function
  EPC_w  = 1, ## niche width
  EPC_MorseA  = 1, ## asymmetry
  EPC_Min = -100,   ## floor to losses 
  
  ### Weather
  TempVary = TRUE, # Logical - does include weather? 
  TempNoise = 0.5, ## sd of Gaussian noise added to temperature across network.  

  ### Climate change
  CC_start = -1, ## which invasion event ('year') to start increasing temperature at. Set to -1 to switch off Climate change
  CC_rate = 0, ## increase in T of environmental matrix per 'year' (outer loop) ==> New_EnvMat <- New_EnvMat*(1+ sppPool$CC_rate*sppPool$SimIter) 
  
  ### Spatial structure and Dispersal 
  mRate = c(1e-4),  # 'migration rate' into a node from neighbours
  dispL = 2,  # dispersal length - effect of distance on dispersal rate. (N.B. this intersects with the adjacency matrix, so no truely long-range dispersal)
  topo=list(no_nodes = no_nodes,   # Number of Nodes to generate
            dMat = NULL, # Euclidean distance matrix between nodes
            T_range = c(0,40), # Vector of 2 numbers. Min and Max temperature across x-axis
            X_length = 40, # max in coord units of length over which temperature varies (scale = 0:X_length)
            xy_ratio = 4 # Ratio of sides of arena. Values above 1 imply larger x (i.e. dimension along which T varies)
  ),
  
  ## Containers 
  
  bMat_p = matrix(NA, 0,no_nodes),  #  matrix of producer biomasses. rows = species, cols = nodes
  rMat= matrix(NA,0,no_nodes),      # matrix of producer growth rates at different sites. rows = species, cols = nodes
  weather_record= c(), ## vector of T shift terms drawn during simulation.
  WeatherRecordMat = matrix(NA,0,500), ## Matrix recording weather as it affects each species. Rows = species, cols = time steps
  p_IDs= c(), ## Vector of IDs of producers present at that point. they look like: P_1_2_3_4. Where 1 is the invasion batch and 2 is the one withinthe invasion batch 3 is invasion round within batch , 4 = Node seeded into
  tVec =  c(), # vector of temperature optima 
  envMat = NULL, # Matrix of values of environmental variables at each node. Rows = e_vars, cols = nodes
  
  ## Trackers and counters
  sppRichness= c(), ## Saves species reachness at each iteration
  SimIter =0,     ## counter for number of time Run_invasion() has been run
  invasion = 0    ## counter for number of species who have invaded successfully
)

