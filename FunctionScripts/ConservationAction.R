ConservationAction <- function( RMat, ## species x site matrix of growth rates in that time step. 
                                envMat, ## 1-d matrix of site values before climate change. 
                                CC, ## number: how much climate change has already happened (shift in space)
                                tVec, ## vector of optimal temperatures
                                Location = 0, # location relative to optima of conservation
                                Width = 1, # total span of the conservation intervention, centered around location
                                Add_Gain  =NULL, ## additive efficacy of conservation
                                Mul_Gain = NULL){## multiplicative efficacy of conservation 0 = nothing, 1 = 100%increase
  
  for( i  in 1:nrow(RMat)){
    ## difference in environment / space, from optima, given CC and offset
    Target_Boolean<-    abs((envMat- tVec[i] - Location + CC))  < (Width/2)  
    
    if( !is.null(Add_Gain)){ RMat[i, ] <- RMat[i, ]  + Target_Boolean*Add_Gain}  ## additive gain
    if( !is.null(Mul_Gain)){RMat[i, ] <- RMat[i, ]  +   RMat[i, ] *Target_Boolean*Mul_Gain } ## multiplicative  gain
  }
  return(RMat) 
}
