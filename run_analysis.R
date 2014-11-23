## Downloading the training and test data sets
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "trainingdata.zip", method = "curl")
unzip("trainingdata.zip")

#importing datasets
x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
features<-read.table("./UCI HAR Dataset/features.txt")
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")

#Appropriately labels the data set with descriptive variable names.
xnames<-c(as.character(features[,2]))
colnames(x_train)<-xnames
colnames(x_test)<-xnames
colnames(y_train)<-"Activity"
colnames(y_test)<-"Activity"
colnames(subject_train)<-"Subject"
colnames(subject_test)<-"Subject"

#Merges the training and the test sets to create one data set.
## binding all training data
train_ds<-cbind(subject_train,y_train,x_train)
## binding all test data
test_ds<-cbind(subject_test,y_test,x_test)
## merging both to a complete training and test data set
complete_ds<-rbind(train_ds,test_ds)

#Extracts only the measurements on the mean and standard deviation for each measurement.
## discarding all but mean and standard deviation columns type and keeping subject and activity columns
mean_std_ds <- complete_ds[, grep("mean|std|Subject|Activity", names(complete_ds))]

#Uses descriptive activity names to name the activities in the data set
actv <- as.character(activity_labels[,2])
## overwriting the Activity ID with descriptive labels
final_ds <- mutate(mean_std_ds, Activity = actv[Activity])

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
melted_ds = melt(final_ds, id.var = c("Subject", "Activity"))
## calculating mean by groups of subject and activity
tidy_ds = dcast(melted_ds , Subject + Activity ~ variable, mean)

#Saving the final tidy data set
write.table(tidy_ds,"final_tidy_data_set.txt", row.names = FALSE)
