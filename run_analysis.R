
# Reading all the files and assigning them to data frames
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("Num","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("ID", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "ID")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "ID")

# combining all the data frame into a single data set
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
mergedData <- cbind(subject, y, x)

# subsetting the data only on the variables containing the mean and SD of the measurements
final_data <- select(mergedData, subject, ID, contains("mean"), contains("std"))

# assigning descriptive names to the activities
final_data$ID <- activities[final_data$ID, 2]

# assigning descrptive names to the variables in the data set
names(final_data)[2] = "activity"
names(final_data)<-gsub("Acc", "accelerometer", names(final_data))
names(final_data)<-gsub("Gyro", "gyroscope", names(final_data))
names(final_data)<-gsub("BodyBody", "body", names(final_data))
names(final_data)<-gsub("Mag", "magnitude", names(final_data))
names(final_data)<-gsub("^t", "time", names(final_data))
names(final_data)<-gsub("^f", "frequency", names(final_data))
names(final_data)<-gsub("tBody", "timeBody", names(final_data))
names(final_data)<-gsub("-mean()", "mean", names(final_data), ignore.case = TRUE)
names(final_data)<-gsub("-std()", "std", names(final_data), ignore.case = TRUE)
names(final_data)<-gsub("-freq()", "frequency", names(final_data), ignore.case = TRUE)

# creating a new data set with the mean values of all measurements grouped by subject and activity
average_data <- final_data %>%
                group_by(subject, activity) %>%
                summarize_all(funs(mean))

# creating a text file of the new data set containing means of all measurements
write.table(average_data, "average_data.txt", row.name=FALSE)


