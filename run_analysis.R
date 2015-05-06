#Get subject ID and activity names
subjectTrain <- read.table("train/subject_train.txt",col.names="subjectID") 
activityTrain <- read.table("train/y_train.txt", col.names="activity")

subjectTest <- read.table("test/subject_test.txt",col.names="subjectID") 
activityTest <- read.table("test/y_test.txt", col.names="activity")

subjectID <- rbind(subjectTrain,subjectTest)
activity <- rbind(activityTrain,activityTest)

activityNames <- read.table("activity_labels.txt",stringsAsFactors = FALSE)
for(i in 1:nrow(activityNames)) {
    row <- activityNames[i,]
    activity$activity[activity$activity == row$V1] <- row$V2
}
initialTidy <- cbind(subjectID,activity)



#build column names for activity data
names <- read.table("features.txt",stringsAsFactors = FALSE)
names <- names[,2]
names <- gsub("()", "", names,fixed = TRUE)
names <- gsub("[[:punct:]]", "", names)
names <- gsub("mean", "Mean", names)
names <- gsub("std", "STD", names)



#Get activity data
activityTrainData <- read.table("train/x_train.txt", col.names=names)
activityTestData <- read.table("test/x_test.txt", col.names=names)
activityData <- rbind(activityTrainData,activityTestData)



#Only use STD and Mean
activityData <- activityData[,grepl("Mean|STD", names(activityData))]
initialTidy <- cbind(initialTidy,activityData)



library(dplyr)
finalTidy <- initialTidy %>%
    group_by(subjectID,activity)%>%
    summarise_each(funs(mean))

write.table(finalTidy,"FinalTidyData.txt",row.names = FALSE)