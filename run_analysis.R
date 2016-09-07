##load the dplyr and tidyr libraries which we'll use to manipulate the dataset later
library(dplyr)
library(tidyr)

##create a "data" directory and download the file, then unzip it
if(!file.exists("data")){dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/wearables_dataset.zip", method="curl")
dateDownloaded <- date()
unzip("./data/wearables_dataset.zip", exdir = "./data")
rm(fileUrl)

##read in each of the relevant files for the training set and combine them into a data frame
directory <- ("./data/UCI HAR Dataset/train")
files <- list.files(directory, full.names = TRUE)
train_data <- read.table(files[2])
train_data <- cbind(train_data, read.table(files[4]))
train_data <- cbind(train_data, read.table(files[3]))
rm(directory, files)

##read in each of the relevant files for the test set and combine them into a data frame
directory2 <- ("./data/UCI HAR Dataset/test")
files2 <- list.files(directory2, full.names = TRUE)
test_data <- read.table(files2[2])
test_data <- cbind(test_data, read.table(files2[4]))
test_data <- cbind(test_data, read.table(files2[3]))
rm(directory2, files2)

##merge the two data frames
wearables_data <- data.frame()
wearables_data <- rbind(test_data, train_data)
rm(test_data, train_data)

##extract the variables with "mean" or "std" in the name
var_names <- read.table("./data/UCI HAR Dataset/features.txt", col.names=c("ID", "description"), stringsAsFactors = FALSE)
means <- var_names[grep(".[m][e][a][n]." , var_names$description),]
stds <- var_names[grep(".[s][t][d].", var_names$description),]
var_names <- rbind(means, stds)
rm(means, stds)

##extract the columns from the large dataset with mean/std data
whichcols <- sort(var_names$ID)
whichcols <- c(1:2, whichcols+2) ##because first two columns are subject and activity
wearables_data <- wearables_data[, whichcols]
rm(whichcols)

##replace the activity ID numbers with descriptive names
activity_names <- read.table("./data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
for(i in 1:6)
{
  wearables_data[[2]] <- sub(i, activity_names[i, 2], wearables_data[[2]])
}
rm(activity_names, i)

##label the columns with the appropriate variable names
colnames(wearables_data) <- c("SubjectID", "Activity", var_names$description)
rm(var_names)

##"melt" the dataset so all variables are in one columns
##this will make it easier to analyze the means for each variable
melted <- gather(wearables_data, variable, measurement, 3:81)
rm(wearables_data)

##group the dataset by subject, activity, and variable
group_data <- group_by(melted, SubjectID, Activity, variable)
rm(melted)

##create a new dataset with the mean for each variable by subject and activity
tidy_data <- summarize(group_data, m = mean(measurement))
rm(group_data)

##"unmelt" the dataset so that we have a tidy dataset with one row for each subject and activity
tidy_data <- spread(tidy_data, variable, m)

##write the new dataset to a file
write.csv(tidy_data, file = "tidy_data.csv")
