# read and name the train and test data

#read features
features <- read.table("./UCI HAR DataSet/features.txt")
#train data
train_data_X <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_data_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(train_data_X) <- features[,2]
colnames(train_data_y) <- "label_id"
colnames(subject_train) <- "subject_label"

#test data
test_data_X <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_data_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(test_data_X) <- features[,2]
colnames(test_data_y) <- "label_id"
colnames(subject_test) <- "subject_label"

#activitiy labels
activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt')
colnames(activity_labels) <- c("label_id","activity name")


# Merges the training and the test sets to create one data set.
train_data_merged <- cbind(train_data_y,subject_train, train_data_X)
test_data_merged <- cbind(test_data_y,subject_test,test_data_X)
all_data_merged <- rbind(train_data_merged,test_data_merged)

#get column names
colNames <- colnames(all_data_merged)

#Extracts only the measurements on the mean and standard deviation for each measurement
mean_std_extracts <- all_data_merged[ ,(grepl("label_id" , colNames)|
                                          grepl("subject_label" , colNames) |
                                          grepl("mean.." , colNames) |
                                          grepl("std.." , colNames)) == TRUE]

#use descriptive activity names to name the activities in the data set
data_with_activity_name <- merge(mean_std_extracts, activity_labels, by = "label_id",all.x = TRUE)

#create a second tidy data set and write into txt file
second_data_set <- aggregate(. ~subject_label + label_id, data_with_activity_name, mean)
write.table(second_data_set[order(second_data_set$subject_label, second_data_set$label_id),],"second_data_set_tidy.txt", row.names = FALSE)



