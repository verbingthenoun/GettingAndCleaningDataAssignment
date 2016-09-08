# GettingAndCleaningDataAssignment
*Assignment materials for the Getting and Cleaning Data Coursera course project.*

The script run_analysis.R downloads the UC Irvine Human Activity Recognition Using Smartphones Data Set and outputs a tidy dataset with an average of each measurement for each subject and activity, where the measurement is either a mean or standard deviation.

The codeebook and R script comments contain additional notes about how to interpret the script and the output dataset.

Thank you to David Hood for a very helpful guide to creating the script and readme file<sup>1</sup>.

The script takes the following steps:

1. Download and unzip the full UCI HAR dataset into a “data” subfolder of the current working directory.

2. Create a file combining the subject, activity, and variable measurements from each of the test and training datasets. I have used cbind() because each file represents one or more columns of the final dataset.

3. “Merge” the test and training datasets using rbind(). I have used rbind() rather than the merge() function because there are no duplicated columns between the two data sets.

4. Extract the appropriate columns (those containing a mean or standard deviation measurement, including meanFreq) and add the correct activity and variable names to the dataframe. The column names are drawn from the list of variable names created at UC Irvine, as these are fairly descriptive names (see code book for more detail).

5. Use the group_by() and summarize() functions to find the average (mean) of each variable. I have used the summarize() function rather than summarise() because I am American :)

6. Create a “tidy” dataset based on Hadley Wickham’s definition of tidy data<sup>2</sup>. As Wickham specifies:

  1. Each variable forms a column: each column in the data set contains either asubject ID, activity name, or measurement for one variable. The name of each column containing the average measurement is the same variable name used by UC Irvine (again, see code book for more detail).
  2. Each observation forms a row: each row in the data set represents the mean measurements for one subject and activity.
  3. Each type of observational unit forms a table: the table contains only one type 	of observational unit, i.e. data collected on a subject performing an activity while using the wearable technology.

7. Output the tidy dataset to csv. 

To read the csv file back into a dataframe, download the csv and use the following R code:

`read.csv(“tidy_data.csv”, header = TRUE, stringsAsFactors = FALSE)`

The script also uses the rm() command to remove excess variables and dataframes.

<sup> 1. David Hood, “Getting and Cleaning the Assignment”, https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/.</sup>

<sup> 2. Hadley Wickham, “Tidy Data”, http://vita.had.co.nz/papers/tidy-data.pdf.</sup>
