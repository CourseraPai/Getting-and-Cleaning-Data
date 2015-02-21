# README.md describing how the script run_analysis.R works

#### 1.Merge training and test sets to create one data set

######1.1 Plan for Y and Subject data sets
* Read the test and train data sets into 2 variables
* Convert each variable into a data frame and ensure both have columns with the same name
* Use rbind to merge the train and test sets
* Once Y data set is created , join Y with activity_labels to update the numeric representation in Y to the labels in activity
* For all steps ensure the dim and variable names are matched

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

######1.2 Plan for X data sets

* Read X_train and X_test files into variables and then subsequently write them into a single file in append mode
* There is a need for pre processing of the X_train and X_test files as the seperation between columns is not even. There is either one or two spaces.Use regular expressions to clean up the inconsistencies
* Write the cleaned data into a file
* The variable X now has the cleaned and merged data in it
* Bind the Subject and Activity data to the clean X dataframe
* There are a few duplicate variable names. Which also means there are duplicate columns in X data. Remove the duplicate columns.
* Also scientific format is difficult to handle when it comes to aggregation. Get the data in numeric format

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
        
        X<-cbind(subject,X)
        X<-cbind(Y,X)
        X<-X[!duplicated(names(X)) ]
        X<-format(X,scientific=FALSE)


#### Name the activities in the data set

* Read activity labels file into a data frame and name the columns appropriately
* Ensure Y's column has been also named the same variable
* Join the two sets by the common column name

        activity_labels<-read.csv("activity_labels.txt",sep=" ",header=FALSE)
        activity_labels<-data.frame(activity_labels)
        names(activity_labels)<-c("Y","Activity")

        Y <- join(Y, activity_labels, by = "Y")
        Y <- Y[,2]

        Y<-data.frame(Y)
        names(Y)<-c("Activity")

#### Label the data set with descriptive variable names

* Load the variable name into features data frame
* Use regular expressions to remove special characters from the names. This would however render the data frame into a vector. But as we are using this only to name the columns of the X data , this is not an issue.
* Now use the vector to name X


        features<-read.csv("features.txt",sep=" ",header=FALSE)
        features<-data.frame(features)
        features<-features[,2]
        features<-gsub("\\(","",features)
        features<-gsub("\\)","",features)
        features<-gsub("\\-","_",features)
        
        names(X)<-factor(features)

#### Extract only Mean and Standard Deviation

* Use Select to filter out the unwanted variables retaining only mean and std dev
* Use Gather to get the data into long format

        tidydata<-X
        tidydata<-select(tidydata,Subject,Activity,contains("mean"),contains("std"),-contains("Freq"),-contains("gravity"))
        tidydata <- gather(tidydata, Feature,Value, (tBodyAcc_mean_X):(fBodyBodyGyroJerkMag_std))
        tidydata$Value<-as.numeric(tidydata$Value)

#### Create a second set with average of each variable for each activity and subject

* Use ddply to average the data grouped by Subject,Activity and Feature columns
* Use seperate to split the variable names on "_" . Here, we have to ensure there are only single "_" in the names
* Use spread to change the data from long to wide format
* Finally , use write.table to write into tidydata.txt

        tidydata<-ddply(tidydata, c("Subject","Activity","Feature"), summarize, value=mean(Value))
        tidydata$Feature<-gsub("_X","X",tidydata$Feature)
        tidydata$Feature<-gsub("_Y","Y",tidydata$Feature)
        tidydata$Feature<-gsub("_Z","Z",tidydata$Feature)
        tidydata <-  separate(tidydata,Feature, c("Feature", "Measure"))
        tidydata<-spread(tidydata, Measure, value,fill=NA)
        names(tidydata)<-c("Subject","Activity","Feature","Mean","Mean-X","Mean-Y","Mean-Z","Standard-Deviation","Standard-Deviation-X","Standard-Deviation-Y","Standard-Deviation-Z")

        write.table(tidydata,"tidydata.txt",row.name=FALSE)