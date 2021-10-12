library(parallel)
library(progress)

setwd('c:\\Users\\Slava\\JupyterProjects\\Stat_Analysis\\RLab')
data <- read.csv("Вячеслав Сергеевич Денисов.csv", colClasses = c("character",rep("double",30) ))

for (i in 1:20)
{
  gen_row <- c()
  for (j in 1:nrow(data))
  {
    gen_row <- append(gen_row, substr(data[[1]][j],i,i))
  }
  
  Genetics <- data.frame(Position_gen_ = gen_row)
  colnames(Genetics) <- paste(colnames(Genetics), i)
  data <- cbind(data, Genetics)
}

i = 0
j = 0

gen_pairs <-matrix(,ncol = 2)
for (i in 1:20)
{
  for (j in (i + 1):20)
  {
    gen_pairs <- rbind(gen_pairs, c(i,j) ) 
  }
}
gen_pairs <- gen_pairs[-1,]
types <- matrix(c(0,0,0,1,1,0,1,1), ncol = 2, byrow = TRUE)

i = 0
j = 0

recombination <- function(i)
{
  
  j = 0
  k = 0

  for (j in 1:nrow(types))
  {
    columns <- c()
    for (k in 1:nrow(data))
    {
      if (data[[gen_pairs[i,1] + 31]][k] == types[j, 1] && data[[gen_pairs[i,2] + 31]][k] == types[j, 2])
      {
        columns <- append(columns, c(1))
      }
      else
       {
        columns <- append(columns, c(0))
       }
    }
    data_recomb <- data.frame(Pair = columns)
    colnames(data_recomb) <- paste(colnames(data_recomb),"(", gen_pairs[i,1], "_", gen_pairs[i,2], ")_", types[j,1], "_", types[j,2], ")")
    data <- cbind(data, data_recomb)
  }
  
  return(data)
}

# system.time({
#   numCores <- detectCores()
#   cl <- makeCluster(numCores)
#   clusterExport(cl, "data")
#   clusterExport(cl, "types")
#   clusterExport(cl,"gen_pairs")
#   clusterExport(cl,"i")
#   #clusterExport(cl,"j")
#   #clusterExport(cl,"k")
#   #clusterExport(cl,"recombination")
#   #clusterEvalQ(cl, recombination)
#   parLapply(cl, 1:nrow(gen_pairs), recombination)
#   stopCluster(cl)
# })

library(foreach)
system.time({foreach(i = 1:nrow(gen_pairs)) %do% {
  data <- recombination(i)
}})






