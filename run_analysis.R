library(plyr)
library(dplyr)
library(tidyr)

activity_labels<-read.csv("activity_labels.txt",sep=" ",header=FALSE)
activity_labels<-data.frame(activity_labels)
names(activity_labels)<-c("Y","Activity")

features<-read.csv("features.txt",sep=" ",header=FALSE)
features<-data.frame(features)
features<-features[,2]
features<-gsub("\\(","",features)
features<-gsub("\\)","",features)
features<-gsub("\\-","_",features)

subject_train<-read.csv("subject_train.txt",sep=" ",header=FALSE)
subject_train<-data.frame(subject_train)
names(subject_train)<-c("Subject")

subject_test<-read.csv("subject_test.txt",sep=" ",header=FALSE)
subject_test<-data.frame(subject_test)
names(subject_test)<-c("Subject")

subject<-rbind(subject_train,subject_test)
subject<-data.frame(subject)
names(subject)<-c("Subject")


Y_train<-read.csv("Y_train.txt",sep=" ",header=FALSE)
Y_train<-data.frame(Y_train)
names(Y_train)<-c("Y")

Y_test<-read.csv("Y_test.txt",sep=" ",header=FALSE)
Y_test<-data.frame(Y_test)
names(Y_test)<-c("Y")

Y<-rbind(Y_train,Y_test)
Y<-data.frame(Y)
names(Y)<-c("Y")


Y <- join(Y, activity_labels, by = "Y")
Y <- Y[,2]

Y<-data.frame(Y)
names(Y)<-c("Activity")

raw_X_train<-readLines("X_train.txt")
raw_X_test<-readLines("X_test.txt")
fileConn<-file("raw_X.txt")
writeLines(raw_X_train, fileConn)
close(fileConn)
fileConn<-file("raw_X.txt","a")
writeLines(raw_X_test, fileConn)
close(fileConn)

raw_X<-readLines("raw_X.txt")
raw_X<-gsub("  "," ",raw_X)
raw_X<-gsub("^ ","",raw_X)
raw_X<-gsub(" ","@",raw_X)

fileConn<-file("raw_X.txt")
writeLines(raw_X, fileConn)
close(fileConn)

X<-read.csv("raw_X.txt",sep="@",header=FALSE)
names(X)<-factor(features)
X<-cbind(subject,X)
X<-cbind(Y,X)
X<-X[!duplicated(names(X)) ]
X<-format(X,scientific=FALSE)

tidydata<-X
tidydata<-select(tidydata,Subject,Activity,contains("mean"),contains("std"),-contains("Freq"),-contains("gravity"))
tidydata <- gather(tidydata, Feature,Value, (tBodyAcc_mean_X):(fBodyBodyGyroJerkMag_std))
tidydata$Value<-as.numeric(tidydata$Value)
tidydata<-ddply(tidydata, c("Subject","Activity","Feature"), summarize, value=mean(Value))
tidydata$Feature<-gsub("_X","X",tidydata$Feature)
tidydata$Feature<-gsub("_Y","Y",tidydata$Feature)
tidydata$Feature<-gsub("_Z","Z",tidydata$Feature)
tidydata <-  separate(tidydata,Feature, c("Feature", "Measure"))
tidydata<-spread(tidydata, Measure, value,fill=NA)
names(tidydata)<-c("Subject","Activity","Feature","Mean","Mean-X","Mean-Y","Mean-Z","Standard-Deviation","Standard-Deviation-X","Standard-Deviation-Y","Standard-Deviation-Z")

write.table(tidydata,"tidydata.txt",row.name=FALSE)
