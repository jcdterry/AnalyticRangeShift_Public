Run_Step<- function(sppPool){
  
  ## Don't vary temp in first 20 steps (prevents an early total wipeout)
  
  if(sppPool$TempVary & nrow(sppPool$rMat)>0  & sppPool$SimIter>20){
    sppPool<-RecalculateGrowthWithNewTemps(sppPool)
  }
  sppPool$S_p = nrow(sppPool$bMat_p) #  // store current diversity
  
  sppPool$SimIter = sppPool$SimIter +1
  if(sppPool$verbose){
    cat(paste('\n \n >>>> \nStarting batch ', sppPool$SimIter , '\n'))
    cat(paste('Weather = ', sppPool$weather_record[sppPool$SimIter], '\n'))
  }
  
  Endpoint_biomasses<-  metaCDynamics_lite(relaxT = sppPool$tMax,sppPool = sppPool)$P_array #  /  'Lite' version, so only returns end point, not the full array
  sppPool <-   clean_extinct(sppPool, Endpoint_biomasses)$sppPool   # Update sppPool Biomass counts Remove extinct species. U
  
  if(sppPool$SimIter%%10 ==1 & sppPool$verbose){
    cat(paste0('\nStep: ',sppPool$SimIter,
               '  Survivors: ',nrow(sppPool$bMat_p)))
    
    print( sppPool$bMat_p)
    
  }
  
  return(sppPool)
}