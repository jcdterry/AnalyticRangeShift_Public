
CalcR_Morse<- function( E_vec, opt, EPC_w, EPC_MorseA, R_Max, EPC_Min ){
  y = E_vec-opt
  R <-  R_Max * (1- ((1 - exp(EPC_MorseA *y))^2)/ (EPC_MorseA^2 * EPC_w^2) ) 
  R[R<EPC_Min] <- EPC_Min
  return(R)
}

CalcR_Harm<- function( E_vec, opt, EPC_w,  R_Max, EPC_Min ){
  y = E_vec-opt  
  R <-  (R_Max * (1 -   ((y^2)/(EPC_w^2))  )  ) 
  R[R<EPC_Min] <- EPC_Min
  return(R)
}

CalcR<- function( E_vec, opt, sppPool){
  # if( sppPool$EPCshape ==   'Pos'){
  #   return(CalcRGamma_Pos( E_vec, opt, sppPool$EPCalpha, sppPool$EPCbeta, sppPool$R_Max, sppPool$EPC_offset, sppPool$EPC_scaler ))
  # }
  # if(sppPool$EPCshape ==  'Neg'){
  #   return(CalcRGamma_Neg( E_vec,  opt, sppPool$EPCalpha, sppPool$EPCbeta, sppPool$R_Max, sppPool$EPC_offset, sppPool$EPC_scaler ))
  # }
  # if(sppPool$EPCshape ==  'Sym'){
  #   return(CalcR_Sym( E_vec,opt,  sppPool$EPC_sd,  sppPool$R_Max,  sppPool$EPC_scaler_Norm ))
  # }
  # 
  # if(sppPool$EPCshape ==  'Harmo'){
  #   return(CalcR_Harm( E_vec,opt,   sppPool$EPC_w, sppPool$R_Max,  sppPool$EPC_Min ))
  # }
  # 
  # if(sppPool$EPCshape ==  'Morse'){
    return(CalcR_Morse( E_vec,opt,  sppPool$EPC_w, sppPool$EPC_MorseA,  sppPool$R_Max,  sppPool$EPC_Min ))
 # }
}




# 
# CalcRGamma_Pos<- function( E_vec, opt, EPCalpha, EPCbeta, R_Max, EPC_offset, EPC_scaler ){
#   return(dgamma(E_vec-opt+EPC_offset, shape =EPCalpha, rate = EPCbeta)*R_Max / EPC_scaler)
# }
# 
# 
# CalcRGamma_Neg<- function( E_vec, opt, EPCalpha, EPCbeta, R_Max, EPC_offset, EPC_scaler ){
#   return(dgamma(opt-(E_vec-EPC_offset), shape = EPCalpha, rate = EPCbeta)*R_Max / EPC_scaler)
# }
# 
# CalcR_Sym<- function( E_vec, opt, EPC_sd, R_Max, EPC_scaler_Norm ){
#   return(dnorm(E_vec, mean =opt ,EPC_sd)*R_Max / EPC_scaler_Norm)
# }

