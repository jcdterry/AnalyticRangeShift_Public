RecalculateGrowthWithNewTemps <- function(sppPool){
  
  n_sp = length(sppPool$tVec)
  n_nodes =sppPool$topo$no_nodes
  rMat_New = matrix( NA, nrow = n_sp, ncol =n_nodes)
  
  ## Calc total climate change:
  
  CC = 0
  if(sppPool$SimIter >= sppPool$CC_start ){
    CC <- (sppPool$CC_rate*(sppPool$SimIter -sppPool$CC_start)) }
  
  ## Calc Weather
  weather<-sppPool$weather_record[max(sppPool$SimIter%% length(sppPool$weather_record),1)]  ### If reach end of weather record, starts again
  
  ## go through each species and calculate R at each node
  for(sp in 1:n_sp ){
    rMat_New[sp,] <-  CalcR(  sppPool$envMat + weather+ CC,   sppPool$tVec[sp],  sppPool)
  }
  sppPool$rMat <-    rMat_New
  
  if(any( is.na(  sppPool$rMat))){browser()}    #  ;if(sppPool$SimIter %%30 ==0){plot(New_EnvMat[1,],rMat[1,] )}
  return(sppPool)
}