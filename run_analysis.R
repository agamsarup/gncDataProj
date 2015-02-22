library("dplyr")

# read description of labels from file
actLabels<-read.table("UCI HAR Dataset/activity_labels.txt",sep = " ",header = F,col.names=c("activity.label","activity.desc"))

# read name of features from file
features<-read.table("UCI HAR Dataset/features.txt",sep=" ",header = F,col.names = c("featColNo","featName"),colClasses = c("featName"="character"))

# calculating logical vector for filtering mean and std features 
isMeanOrStd<-sapply(features[,c(2)], grep, pattern="mean|std",simplify = T) 
isMeanOrStd<-isMeanOrStd==1
isMeanOrStd<-!is.na(isMeanOrStd)

# column indices of mean and std features
indices<-which(isMeanOrStd, useNames = TRUE)

# customising colClasses to select only the columns of interest i.e. mean and std columns
classVector<-rep("NULL",561)
classVector[indices]<-"character"

# obtaining feature names using indices
selectFeatures<-features[,2][indices]

# reading train data from file
xtrainData<-read.table("UCI HAR Dataset/train/X_train.txt",header = F,sep = "",colClasses = classVector)

# updating column names
colnames(xtrainData)<-selectFeatures

# reading test data from file and updating column names
xtestData<-read.table("UCI HAR Dataset/test/X_test.txt",header = F,sep = "",colClasses = classVector)
colnames(xtestData)<-selectFeatures

# reading subject data from train and test file
trainSubjects<-read.table("UCI HAR Dataset/train/subject_train.txt",header = F)
testSubjects<-read.table("UCI HAR Dataset/test/subject_test.txt",header = F)

# Adding the subject data as column to train and test data
xtrainData$subject<-trainSubjects[,1]
xtestData$subject<-testSubjects[,1]

# reading label data from train and test file
ytrainData<-read.table("UCI HAR Dataset/train/y_train.txt",header = F,sep = "")
ytestData<-read.table("UCI HAR Dataset/test/y_test.txt",header = F,sep = "")

# Adding the label data(description of labels) as column to train and test data
xtrainData$label<-actLabels[ytrainData[,1],2]
xtestData$label<-actLabels[ytestData[,1],2]

#binding the train and test data into a single data frame
binded<-rbind.data.frame(xtestData,xtrainData)

# writing the table back to a separate file
# write.table(binded,"binded.txt",quote = F,row.names = F)

# converting type of mean and sd columns from "character" to "numeric"
for(i in c(1:(ncol(binded)-2))) {
  binded[,i] <- as.numeric(binded[,i])
}

#grouped<-group_by(binded,subject,label)
# calculating mean and sd for each combination of subject and label
summaryData<-binded %>% group_by(subject,label) %>% summarise_each(funs(mean,sd))
write.table(summaryData,file ="step5.txt",row.names = F,quote = F)

#write.table(colnames(summaryData),"CodeBook.md",row.names = F,quote=F,col.names = F)