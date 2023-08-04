# install.packages("stlplus")
library(stlplus)
library(xts)
library(ggplot2)

datasets_path <- "/home/jhzhou/repos/tourism-imputation/data"

datasets <- c(
"au-block5.csv",
"au-block10.csv",
"au-random5.csv",
"au-random10.csv",
"ph-block5.csv",
"ph-block10.csv",
"ph-random5.csv",
"ph-random10.csv",
"sg-block5.csv",
"sg-block10.csv",
"sg-random5.csv",
"sg-random10.csv",
"us-block5.csv",
"us-block10.csv",
"us-random5.csv",
"us-random10.csv",
"th-block5.csv",
"th-block10.csv",
"th-random5.csv",
"th-random10.csv",
"uk-block5.csv",
"uk-block10.csv",
"uk-random5.csv",
"uk-random10.csv"
)

for(path in datasets){
  train_path <- paste(datasets_path, "/miss_data/", path, sep = "")
  train_data_statiton <- read.csv(file = train_path, header = TRUE, sep = ",")
  vals <- c(1:97)
  for(i in vals){
    time_serise = ts(train_data_statiton[,i], frequency = 12)
    print(i)
    stl2 = stlplus(time_serise, s.window = "periodic")
    trend = stl2$data[,"trend"]
    seasonal = stl2$data[,"seasonal"]
    remainder = stl2$data[,"remainder"]
  
    if(i == 1){
      train_trend_dataframe = data.frame(col1 = trend)
      train_seasonal_dataframe = data.frame(col1 = seasonal)
      train_remainder_dataframe = data.frame(col1 = remainder)
    } else {
      train_trend_dataframe[,paste(i)] = trend
      train_seasonal_dataframe[,paste(i)] = seasonal
      train_remainder_dataframe[,paste(i)] = remainder
    }
  }
  #stem = strsplit(path, split = ".csv")[1]
  write.csv(train_trend_dataframe    ,paste(datasets_path, "/decomposition/trend/"    ,path, sep = ""))
  write.csv(train_seasonal_dataframe ,paste(datasets_path, "/decomposition/seasonal/" ,path, sep = ""))
  write.csv(train_remainder_dataframe,paste(datasets_path, "/decomposition/remainder/",path, sep = ""))
}