List of files in the repo-
1. run_analysis.R - R code for tidying the data
2. CodeBook.md - Describes the variables, the data, and any transformations or work performed to clean up the data
3. README.md - This file containing general instructions and explanation of working of scripts

---------------------
Script Working
---------------------

It is assumed that the working directory has `UCI HAR Dataset` folder.
There is only one script i.e. `run_analysis.R` which does all the work.
The following are the steps followed in the process which can also be 
understood by reading the comments in the run_analysis.R file.

1. The description of labels is read from file "UCI HAR Dataset/activity_labels.txt" using read.table.

2. The name of the features is read from "UCI HAR Dataset/features.txt" file using read.table.

3. After observing the features it was concluded that mean and std variables contain "mean" and "std"
strings as sub-strings. So, used grep to filter these variables by creating a logical vector which stores T for
the feature that needs to be selected and F otherwise. Used this vector to get column indices and subsequently the feature names.

4. Customised colClasses to select only the columns of interest i.e. mean and std columns

5. Read train data from file and updated column names. Similarly, read test data.

6. Read subject and label data from train and test file.

7. Added the subject,label data as a column to train and test data

8. Binded the train and test data into a single data frame by using rbind.data.frame.

9. Converted type of mean and sd columns from "character" to "numeric"

10. Calculated mean and sd of each mean, sd column for each combination of subject and label
by using group_by and summarise_each functions.

11. FInally, wrote the data to a file "step5.txt".