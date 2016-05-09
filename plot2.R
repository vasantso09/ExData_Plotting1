#Download and check if file exists

if (!(file.exists("./exdata-data-household_power_consumption.zip"))) {
  download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "./", method = "wget")
  unzip(zipfile = "./exdata-data-household_power_consumption.zip", exdir = "./")
}

#Extract Date column and find the rows that equal 2/1/2007 and 2/2/2007
date_from_table = read.table("./household_power_consumption.txt",sep = ";", na.strings = "?",colClasses = c("character", rep("NULL",8)), header = TRUE, nrows = 200000)
extract_rows = unique(grep("^1/2/2007$|^2/2/2007$",date_from_table[, "Date"]))
rm(date_from_table)
#Subset the data by the extract_rows vector 
All_Data = read.table("./household_power_consumption.txt",sep = ";", na.strings = "?",colClasses = "character",  header = TRUE, nrows = 200000)[extract_rows,]
rm(extract_rows)

#Set up variables to be used in the plots
All_Data$Date_Time =  strptime(paste(All_Data$Date, All_Data$Time, sep=" "),format("%d/%m/%Y %H:%M:%S"))
All_Data$Date = as.Date(All_Data$Date, format = "%d/%m/%Y")
All_Data$Global_active_power <- as.numeric(All_Data$Global_active_power)
head(All_Data)

#Create the plots
png(filename ="plot2.png", width = 480, height = 480, bg= "white")
plot(x = All_Data$Date_Time, y = All_Data$Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")
dev.off()
rm(All_Data)