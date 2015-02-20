###### "Getting & Cleaning Data Course Project - CodeBook"

This is a code book that describes the variables that are used in the accompanying run_analysis.R program. The variables below are in the order they occur in the program. This should help in understanding the flow better.

activity_labels       Data Frame that holds data from the activity_labels file.Has the following 2 columns
                      Y: int  1 2 3 4 5 6
                    	ACTIVITY: Factor 	WALKING
                        	             	WALKING_UPSTAIRS
						                            WALKING_DOWNSTAIRS
						                            SITTING
						                            STANDING
						                            LAYING
                      dim: 6 X 2
                    
features		          Vector of length 561 that holds data from the features file
			                "tBodyAcc_mean_X" "tBodyAcc_mean_Y" "tBodyAcc_mean_Z" "tBodyAcc_std_X"  "tBodyAcc_std_Y"  "tBodyAcc_std_Z" ..........


subject_test					Data Frame that holds data from the subject file from the test folder
                      Subject: 2,4,9,10,12,13,18,20,24
                      dim: 2947 X 1
                      
subject_train  				Data Frame that holds data from the subject file from the train folder
                      Subject: 1,3,5,6,7,8,11,14,15,16,17,19,21,22,23,25,26,27,28,29,30
                      dim: 7352 X 1

subject       				Data Frame that holds data by merging the test and train subject data
                      Subject: 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
                      dim: 10299 X 1
                      
Y_test  				      Data Frame that holds actual recorded activity data from the Y file from the test folder
                      Y: 1,2,3,4,5,6
                      dim: 2947 X 1
                      
Y_train  				      Data Frame that holds actual recorded activity data from the Y file from the train folder
                      Y: 1,2,3,4,5,6
                      dim: 7352 X 1

Y              				Data Frame that holds data by merging the test and train Y data
                      Y: 1,2,3,4,5,6
                      dim: 10299 X 1

raw_test  			      Variable that holds data from the X file from the test folder                  

raw_train    		      Variable that holds data from the X file from the test folder
                                      
raw_X       		      Variable that holds data by merging the test and train X data, intermediately

X                     Data Frame that holds data from the raw_X variable after removing duplicate varaiable names from the features vector
                      dim: 10299 X 479
                      
tidydata              Data Frame that holds the final tidy data with filtered Mean and Std Deviation related measures only
                      dim: 2700 X 11
                    
