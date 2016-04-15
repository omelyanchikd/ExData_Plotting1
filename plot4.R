# ask for name of the file with the source data
filename <- readline("Please specify a name of the file you want to upload (including path): ")

# default values for runnning on my computer
if (filename == "")
  filename <- "C:/Users/Diana/Downloads/household_power_consumption.txt"

# read data (only the lines, which correspond to the dates of interest)
input <- read.table(filename, header = TRUE, sep = ";", dec = ".", na.strings = "?", 
                    stringsAsFactors = FALSE, skip = 66636, nrows = 2880)

# change column names to appropriate ones
names(input) <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", 
                  "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

# date should be recognised as a date
input$Date <- as.Date(input$Date, format = "%d/%m/%Y")

# redundant check (that's how I know which lines to skip and how many rows to read)
input<- input[input$Date >= as.Date("2007-02-01") & input$Date <= as.Date("2007-02-02"),]

# we need new variable to be able to plot points like Thursday, Feb 1, 00:00
input$datetime <- strptime(paste(input$Date, input$Time), format = "%Y-%m-%d %H:%M:%S")

# needed if you are not using English locale
Sys.setlocale("LC_TIME","English")

# select destination for new chart
output<- readline("Specify a folder to save created chart: ")
if (output == "")
  output<-"D:/R Programming/ExData_Plotting1/"

# specify graphical device to save chart
png(filename = paste(output, "plot4.png"))

#create chart
par(mfrow = c(2, 2))
par(mar = c(4, 4, 1, 1))
plot(input$datetime, input$Global_active_power, type = "l", xlab = "",
     ylab = "Global Active Power")

plot(input$datetime, input$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

plot(input$datetime, input$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
lines(input$datetime, input$Sub_metering_1, col = "black")
lines(input$datetime, input$Sub_metering_2, col = "red")
lines(input$datetime, input$Sub_metering_3, col = "blue")

legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1,1), 
       col = c("black", "red", "blue"), cex = 0.5, bty = "n")

plot(input$datetime, input$Global_reactive_power, type = "l", xlab = "datetime", 
     ylab = "Global reactive power")

#turn off device after usage to save chart
dev.off()

