
metaCDynamics_lite <- function( relaxT, sppPool) {
  
  # this version only returns the end state of the community
  
  
  rMat   = sppPool$rMat
  dMat = sppPool$dMat_n
  timescale = sppPool$timescale   
 
  B_prod<- sppPool$bMat_p
  
  for( t_step in 2:(relaxT+1)){  # Run through time steps
    local_change_P = B_prod * (rMat - diag(nrow = nrow(rMat)) %*% B_prod )# Convert from per-producer gain rates, to total changes
    immigration_P <- B_prod %*% dMat                                      # Calculate dispersal
    B_prod <- B_prod + (local_change_P + immigration_P) *timescale # Combine
    if(any( B_prod<0)){
      B_prod[B_prod<0]<-0                                # removing any below zero (NB not thresholding here, just catching negatives)      
    }
  }
  return(list(P_array = B_prod))
}
