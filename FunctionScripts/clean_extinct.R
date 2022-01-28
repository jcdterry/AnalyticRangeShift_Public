clean_extinct<- function(sppPool,
                         Endpoint_biomasses) {
  
  n_p <- nrow(sppPool$bMat_p)
  
  ### Cleaning up in case dropped dimensions
  if(!is.null(Endpoint_biomasses)){Endpoint_biomasses<- matrix(Endpoint_biomasses, nrow =n_p )}
  
  #scan biomass matrices for regionally extinct species and remove corresponding vectors from model matrices 
  thresh <- sppPool$thresh   # - detection/extinction threshold
  
  # Find extant status
  ind_p = apply(Endpoint_biomasses > thresh, 1, any) #  search for populations above threshold across any nodes
  
  
  # retain only rows of species that still persist model objects
  sppPool$bMat_p<- Endpoint_biomasses[ind_p,,drop=FALSE]  
  sppPool$rMat<-  sppPool$rMat[ind_p,,drop=FALSE] 
  
  
  sppPool$sVec<-  sppPool$sVec[ind_p,drop=FALSE] 
  sppPool$tVec <- sppPool$tVec[ind_p,drop=FALSE] 
  
  
  if(sppPool$verbose){if(any(!ind_p)){cat(sppPool$p_IDs[!ind_p])}}
  
  # Cut down IDs
  sppPool$p_IDs<- sppPool$p_IDs[ind_p]
  
  ## Any values far below threshold also set to zero, to speed up computations
  sppPool$bMat_p[sppPool$bMat_p< (thresh/100)]<-0
  ### double check no negatives
  sppPool$bMat_p[sppPool$bMat_p<0]<-0
  
  return(list(sppPool = sppPool,
              Prod =  sppPool$bMat_p))
}