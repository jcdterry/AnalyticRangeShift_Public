PopulateSystem  <- function(sppPool, no_invaders=100){  
  
  #### Adding 100 new species
  if(sppPool$verbose){cat(paste('Adding', no_invaders, 'species'))}
  
  sppPool$tVec<- runif(no_invaders,sppPool$OptRange[1], sppPool$OptRange[2])  ## Optima drawn from specified range of optima sppPool$OptRange
  
  # intially biomass 0 everywhere. 
  sppPool$bMat_p <- matrix(0, nrow = no_invaders, ncol = sppPool$topo$no_nodes)
  
  
  #find node with mean E closest to each species generated optimum
  StartNode<-max.col(-abs(outer(as.vector(sppPool$tVec), as.vector(sppPool$envMat), '-')))
  
  ######## Each invader given a density of 10 near its optimum, and allowed to expand.
  for(sp_i in 1:no_invaders ){
    sppPool$bMat_p[sp_i,StartNode[sp_i] ] <- 10  
    
  }
  
  ## Assign unique IDs to each species
  sppPool$p_IDs<- paste0('SP_', 1:no_invaders,'_start_', StartNode)
  
  
  ## growth rates 
    n_sp = length(sppPool$tVec)
    n_nodes =sppPool$topo$no_nodes
    rMat_New = matrix( NA, nrow = n_sp, ncol =n_nodes)
    
    ## Don't include weather 
    ## go through each species and calculate R at each node
    for(sp in 1:n_sp ){
      rMat_New[sp,] <-  CalcR(  sppPool$envMat, sppPool$tVec[sp],  sppPool) 
    }
    sppPool$rMat <-    rMat_New

  return(sppPool)
}