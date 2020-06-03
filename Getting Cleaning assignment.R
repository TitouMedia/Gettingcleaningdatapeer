# Peer Graded Assignment: Getting and Cleaning Data Course Project


# Extract list of features and list of activities
features_list <- read.table("features.txt", col.names = c("no","features"))
activity <- read.table("activity_labels.txt", col.names = c("label", "activity"))

# Process test dataset into one single dataframe
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features_list$features)
y_test <- read.table("test/Y_test.txt", col.names = "label")
y_test_label <- left_join(y_test, activity, by = "label")

# Transform it to a tidy dataset
tidy_test <- cbind(subject_test, y_test_label, x_test)
tidy_test <- select(tidy_test, -label)

# Process training dataset into one single dataframe
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features_list$features)
y_train <- read.table("train/Y_train.txt", col.names = "label")
y_train_label <- left_join(y_train, activity, by = "label")

#Transform training data into a tidy dataset

tidy_train <- cbind(subject_train, y_train_label, x_train)
tidy_train <- select(tidy_train, -label)


# combine test and training data sets
tidy_set <- rbind(tidy_test, tidy_train)

# Extract mean and standard deviation
tidy_mean_std <- select(tidy_set, contains("mean"), contains("std"))

# Average all variables by each subject each activity
tidy_mean_std$subject <- as.factor(tidy_set$subject)
tidy_mean_std$activity <- as.factor(tidy_set$activity)

tidy_avg <- tidy_mean_std %>%
  group_by(subject, activity) %>%
  summarise_each(list(mean=mean))

#Prepair csv file of tidy_avg
write.csv(tidy_avg, "tidy_avg.csv")
