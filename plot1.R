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
#creates time and date class
setClass("myDate")
setClass("myTime")
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )
setAs("character","myTime", function(from) strptime(from, format="%H:%M:%S") )
#read table
print("Reading data table")
dPower = read.table(sDataFile,sep=";",header=T,colClass=c("myDate","myTime","numeric","numeric","numeric","numeric","numeric","numeric","numeric"),na.string="?")
unlink(sDataFile)
#creates device intance
print("Generating plot")
png(filename = "plot1.png",width = 480,height = 480,units = "px")
#creates plot
hist(dPower[dPower$Date %in% as.Date(vDates),]$Global_active_power,breaks=13,freq=T,col="red",xlab = "Global Active Power (kilowatts)",main="Global Active Power")
#closes device
dev.off()
print("File generated")