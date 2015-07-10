#downloads data set if needed
sDataPath = "data"
sDataName = "household_power_consumption.txt"
sURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
vDates = c("2007-02-01","2007-02-02")

if (!dir.exists(sDataPath)){
  print("No data folder. Creating directory.")
  dir.create(sDataPath)
}
sDataFile = paste(sDataPath,sDataName,sep="/")
if (!file.exists(sDataFile)){
  
  if(!file.exists(paste0(sDataFile,".zip"))){
    print("File not found. Downloading data file")  
    download.file(sURL,destfile = paste0(sDataFile,".zip"),method="libcurl")
  }
  else{
    print("zipped file found.")
  }
  print("unzipping file")
  unzip(paste0(sDataFile,".zip"),exdir=sDataPath)
}
#creates date class
setClass("myDate")
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )
#read table
print("Reading data table")
dPower = read.table(sDataFile,sep=";",header=T,colClass=c("myDate","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"),na.string="?")
unlink(sDataFile)
#creates device intance
print("Generating plot")
png(filename = "plot2.png",width = 480,height = 480,units = "px")
#subsets
dPower = dPower[dPower$Date %in% as.Date(vDates),]
#creates POSIXct date-time column
dPower["fullTime"] = as.POSIXct(paste(as.character(dPower$Date),as.character(dPower$Time)),format="%Y-%m-%d %T")
#creates plot
with(dPower,plot(fullTime,Global_active_power,type="l",ylab = "Global Active Power (kilowatts)",xlab=""))
#closes device
dev.off()
print("File generated")