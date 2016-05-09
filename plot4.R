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
png(filename ="plot4.png", width = 480, height = 480, bg= "white")
par(mfrow = c(2,2))
with(All_Data, plot(x =Date_Time , y = Global_active_power, type = "l",xlab = "", ylab = "Global Active Power"))
with(All_Data, plot(x =Date_Time , y = Voltage, type = "l",xlab = "datetime", ylab = "Voltage"))

with(All_Data, plot(x = Date_Time, y = Sub_metering_1, type = "l",xlab = "", ylab = "Energy sub metering", col = "black"))
with(All_Data, lines(x=Date_Time, y =Sub_metering_2, col = "red"))
with(All_Data, lines(x = Date_Time, y = Sub_metering_3, col = "blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red","blue"), lty = 1)

with(All_Data, plot(x = Date_Time, y = Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power", col = "black" ))
dev.off()
rm(All_Data)