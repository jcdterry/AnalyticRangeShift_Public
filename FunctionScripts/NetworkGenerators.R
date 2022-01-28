
genNetwork<- function(sppPool) {
  
  no_nodes<- sppPool$topo$no_nodes    #- number of nodes in spatial network
  randGraph <- sppPool$topo$randGraph # - select random planar graph (T) or regular lattice (F)
  
  #  Sample coordinates of patches 

    xcoord =  round(runif( no_nodes,0, sppPool$topo$X_length),digits = 2) 
    ycoord =  round(runif( no_nodes,0, sppPool$topo$X_length/sppPool$topo$xy_ratio),digits = 2)
    network = matrix(c(xcoord, ycoord), no_nodes,2)
    
    #  List nodes in order of x-coord 
    network<- network[order(network[,1]), ]
    
    if (is.null(sppPool$topo$distMat)) {sppPool$topo$distMat = as.matrix(dist(network, method = 'euclidean'))} #// generate distance matrix
    if (is.null(sppPool$topo$adjMat))  {sppPool$topo$adjMat <- genAdjMat(network, sppPool$topo)} #   // generate adjacency matrix
  
  sppPool$network <- network
  return(sppPool)
}

genAdjMat<- function(network, topo) {

  no_nodes <- topo$no_nodes

    #Gabriel algorithm 
    
    distance<- function( x1,  y1,  x2,  y2){
      return((x1-x2)^2) + ((y1-y2)^2)
    }
    
    adjMat<- matrix(0,no_nodes,no_nodes)    #  // initialize adjMat
    
    for(i in 1:no_nodes) {
      for(j in i:no_nodes) {
        if(i != j){
          
          mx=(network[i,1] + network[j,1])/2 # mid points between nodes i and j
          my=(network[i,2] + network[j,2])/2
          
          rad=  ((mx-network[i,1])^2)+((my-network[i,2])^2) # radius of diameter circle (from midpoint to node i)
          ## NB not square rooting, so really rad^2
          
          OtherNodes<-(1:no_nodes)[-c(i,j)]
          ## If all other nodes are outside squared radius, then make a link
          SqDistToOtherNodes<-((mx-network[OtherNodes,1])^2)+ ((my-network[OtherNodes,2])^2)
          adjMat[i,j] <- all( SqDistToOtherNodes> rad)
          adjMat[j,i] <- all( SqDistToOtherNodes> rad)
        }
      }
    }
    diag(adjMat)<- 0# // only diagonal elements set to zero

  return(adjMat)
}

genTempGrad <- function(sppPool) {
  
  topo <- sppPool$topo 
    T_x =   topo$T_range[1] +   ((topo$T_range[2]-topo$T_range[1])  * sppPool$network[,1]/ max(sppPool$network[,1])) # x coord of network used to define gradient
    envMat = matrix(T_x, nrow = 1)  #   define linear temperature gradient in single dimension. 
    return(envMat)     

}

genDispMat<- function(sppPool) {

  dispL <- sppPool$dispL   # dispL - dispersal length
  mRate <- sppPool$mRate #  migration rate
  topo <-   sppPool$topo
  
  if (topo$no_nodes == 1) {
    dMat_n<-matrix(0,1,1)
  } else {
    
    dMat_n = exp(-topo$distMat/dispL)   * topo$adjMat
    
      # Normalise by total adjacent dispersal 
      dMat_n =  mRate* dMat_n  / matrix(colSums(dMat_n), byrow = TRUE, nrow(dMat_n), nrow(dMat_n))
      diag(dMat_n) <- -1*mRate       # note the dispersal operator includes the (negative) emigration terms on the diagonal
  }
  sppPool$dMat_n <- dMat_n
  return(sppPool)
}



