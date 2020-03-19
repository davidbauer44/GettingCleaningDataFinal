############################
#  Getting and Cleaning Data
#  Final Project
#  David Bauer
#  March 2020
#############################

require(dplyr)

# You should create one R script called run_analysis.R that does the following.

# Merges the training and the test sets to create one data set.
feat = read.table("UCI HAR Dataset/features.txt", as.is = TRUE)
x1 = read.table("UCI HAR Dataset/test/X_test.txt", colClasses = "numeric", col.names = feat$V2)
y1 = read.table("UCI HAR Dataset/test/Y_test.txt", colClasses = "numeric")
sub1 = read.table("UCI HAR Dataset/test/subject_test.txt", colClasses = "numeric")
x2 = read.table("UCI HAR Dataset/train/X_train.txt", colClasses = "numeric", col.names = feat$V2)
y2 = read.table("UCI HAR Dataset/train/Y_train.txt", colClasses = "numeric")
sub2 = read.table("UCI HAR Dataset/train/subject_train.txt", colClasses = "numeric")

xfull = rbind(x1, x2)
yfull = rbind(y1, y2)
subfull = rbind(sub1, sub2)


# Extracts only the measurements on the mean and standard deviation for each measurement.
meanindex = grep("[Mm]ean", names(xfull))
stdindex = grep("[Ss][Tt][Dd]", names(xfull))

x = xfull[, c(meanindex, stdindex)]


# Uses descriptive activity names to name the activities in the data set
act = read.table("UCI HAR Dataset/activity_labels.txt", as.is = TRUE)
y = inner_join(yfull, act)$V2  # Default works; V1 == V1
dim(y) = c(length(y), 1)
colnames(y) = "Activity"
names(subfull) = "Subject"
df = cbind(y, subfull, x)


# Appropriately labels the data set with descriptive variable names.
# Initial part done during reading
names(df) = gsub("[.]+", " ", names(df))


# From the data set in step 4, creates a second, independent tidy data set with the average of each
# variable for each activity and each subject.
df = tbl_df(df)
df = group_by(df, Activity, Subject)
tds = summarize_all(df, mean)

write.csv(tds, "Tidy Data Set.csv")

