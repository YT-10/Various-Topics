#tidyverse

#Author: Yusuf Tatlier

require(tidyverse)

#####

### Part 1: String operations ----

  #String operations and regular expressions are important in working with tidy data

  #Some basic operations
test_string=" abc-2017 "
str_length(test_string) #Length of string, includes spaces
str_trim(test_string) #Removes spaces at start and end
str_sub(test_string,1,4)  #Gives a substring, starting at position 1 until 4

  #R doesn't perform (direct) arihtmetic on strings, which some languages do 
print(test_string+test_string) #Doesn't work
str_dup(test_string,2) #Duplicates strings

  #Splitting and joinging strings
str_c("First string","-","Second string") #Joining strings
comb_str=str_c(c("word1","word2","word3"),collapse="-") #Joins strings in a vector
print(comb_str)
str_split(comb_str,"-")  #Splitting strings
str_split_fixed(comb_str,"-",3)  #Splitting strings into 3 elements

  #Changing strings
str_to_upper(test_string) #Changing letters to upper case
str_replace(test_string," ","*") #Replace first occurence
str_replace_all(test_string," ","*") #Replace all occurences

  #Detecting (sub-)strings
name_vector<-c("Mr. Kennedy","Mrs. Jackson","Mrs. Smith","Mrs. Anderson","Mr. Diaz")
  #Detecting strings can be done with grepl and grep, but also using stringr functions
grep("Mr.",name_vector,fixed=TRUE) #Matches strings, without fixed also admits "Mrs"
grepl("Mr.",name_vector,fixed=TRUE) #Returns indices of occurences
gsub("Mr.","mr.",name_vector,fixed=TRUE)
str_detect(name_vector,"Mr.") #Will also return the Mrs, as "." stands for any character in regex syntax
str_detect(name_vector,fixed("Mr.")) #Now only returns fixed matches
str_which(name_vector,fixed("Mr."))

  #Some regular expressions
new_str="31R47-88Q32-90i66-120uu09-22KL21"
new_vec=str_split(new_str,"-")

  #Important regex (Leave out '', only used for specifying character)
# '.' stands for any character
# '*' 0 or more time, '?' 0 or 1 times, '+' 1 or more times, '{n}' exact of n times. These
# need to added behind stamps.
# '^' stands for start of line, '$' stands for end of line
# '[A-Z]' stands for any letter between A and Z, '[0-9]' is similar for numbers

  #Look whether some combinations occur
str_detect(new_str,"u{2}") #Looks for the combination "uu"
str_detect(new_vec,"u{2}")
str_detect(new_str,"u{3}") #Looks for the combination "uuu"
str_detect(new_str,"u{2}[0-9]+") #Looks for the combination uu with at least two numbers
str_detect(new_str,"u{2}[1-9]+") #Looks for the combination uu with at least two numbers, excluding 0
str_detect(new_str,"[A-Z]{2}[0-9]+") #Looks for two letters and at least two numbers
str_detect(new_str,"[A-K]{2}[0-9]+") #Looks for two letters from A-Z and at least two numbers
  #Retrieve the combinations
str_match(new_str,"[A-L]{2}[0-9]+")
str_match(new_str,"u{2}[0-9]")
str_match(new_str,"[A-Z?*[0-9]+$") #Looks for the combination at the end of the line
str_match(new_str,"u{2}[0-9].*$") #Gives string until the end

### Part 2: Date operations ----
  # lubridate provides simple ways for data parsing and transformations

  #Current time
cur_time=now()
month(cur_time)
year(cur_time)<-2020
print(cur_time)

  #Date arithmetic
fut_time=cur_time+years(2)
new_date_1<-ymd(20190101)
new_date_2<-ymd(20190502)
difftime(new_date_2,new_date_1,unit="weeks")

  #Changing date formats
format(cur_time,"%d-%m-%Y")

### Part 3: tibbles ----

  ### We will use the datasets iris,  diamonds and self created tibbles

  #Differences and advantage of tibbles (compared to dataframes):
#  - By default shows first 10 rows
#  - In subsetting it is not necessary to reference to the object itself
# 
#  - Libraries in tidyverse are made to work with tibbles

  #Convert dataframe into a tibble
tbl<-tbl_df(iris)
class(tbl)

  #Explore the tibble
glimpse(diamonds)
view(diamonds)
dim(diamonds)

  #Create a tibbe
  #tibble with artificial data on soccer player data for 2008-2012
goal_tbl=tibble(year=c("2008","2009","2010","2011","2012","2012"),
                club=c("AZ","Ajax","Ajax","Ajax","Vitesse","Vitesse"),
                games=c(32,12,21,19,12,12),
                goals=c(22,3,9,8,7,7))

  #Note that last row is a duplicate
goal_tbl_unique<-distinct(goal_tbl)

  #The following two objects are different
tbl$Species #Is not a tible, but a numeric vector
tbl[,5]
  #However the first is the same as the next object
identical(tbl$Species,tbl[[5]])

  #Slicing tibbles
  #Same slicing as for dataframes applies to tibbles
tbl[1,] #First row
tbl[,1] #First column
names(tbl) #(column) names
tbl$Species #column selection
tbl["Species"=="setosa","Sepal.Length">5] #Note it is not necessary to reference tbl, however
#column names need to be specified between quotation marks

  #Apply functions on tibbles
  #Apply functions can be applied similarly
apply(tbl[,1:4],2,sum)
apply(tbl,2,n_distinct)
sapply(tbl[,1:4],sum)
tapply(tbl$Sepal.Length,tbl$Sepal.Length,sum) #Note that tbl[,i] will result in an error 

  #Map functions
map_iris<-map(tbl[1:4],mean) #More flexible than the apply functions as can be seen
map_iris  #Is a list
unlist(map_iris)  #Converts the list to a vector, can be very useful

  #There are many different map functions depending on the type of the output
map_dbl(1:4,sqrt)
map_dbl(1:4,as.character) #Returns an error as output needs to be a double
map_chr(c(1,2,3),sqrt)  #Returns a character vector

  #Function can be repeated handily using the pipe operator
tbl[,1:4] %>% map(function(x)(x^2)) %>% map(sum)

  #purrr package supports handy tools for working with anonymous functions
tbl[,1:4] %>% map(~(.x^2)) %>% map(sum) #Note that the dot in front of the variable is 
#necessary in the syntax as otherwise the global variable will be used if it exists

#Merge and join
country_tbl<-tibble(id=c(1,2,3,4,5),
                    country=c("Netherlands","Turkey","Russia","Germany","Japan"),
                    Continent=c("Europe","Europe","Europe","Europe","Asia"))
visit_tbl<-tibble(id=c(1,2,2,4,2),capital=c("Amsterdam","Ankara","Ankara","Berlin","Ankara"),
                  visit_year=c(2015,2014,2016,2019,2019))

merge(country_tbl,visit_tbl,key="id")
left_join(country_tbl,visit_tbl,by="id") #Left joins
left_join(visit_tbl,country_tbl,by="id") 
right_join(country_tbl,visit_tbl,by="id") #Right join, different order from previous line
inner_join(visit_tbl,country_tbl,by="id") #Inner join
full_join(visit_tbl,country_tbl,by="id") #Full or outer join

#dplyr contains functions that can be used for data wrangling
#Important functions are filter, select, arrange, mutate, summarize

#Subsetting using dplyr
  #rows
filter(diamonds,cut=="Ideal",price>400) #Baed on values
filter(diamonds,cut=="Ideal" & price>400) #equivalent to above
slice(diamonds,-c(3,4,5)) #Leave out certain rows
slice(diamonds,100:400) #Selecting specific rows
head(diamonds,5) #Select first 5 rows
tail(diamonds,5) #Select last 5 rows

  #cols
select(diamonds,carat,cut,price)
map(select(tbl,-Species),mean) #Provides an easy way to leave out undesired columns

#sampling
sample_n(diamonds,10,replace=TRUE) #Sampling with replacement, replace=FALSE without replacement

#Arrange
arrange(diamonds,desc(cut),color,price) #Arrange on cut by reverse order, colr and then price

#mutate
mutate(diamonds,price/carat)

#Operations over rows and columns
summarize(tbl,col_1=mean(tbl$Sepal.Length),col_2=sd(tbl$Sepal.Width))
summarize_each(tbl,n_distinct) #similar to apply over columns
summarize_each(tbl,n_distinct,-Species) #Leave out columns

#Aggregating by using combination of group_by and summarize
#group_by() operation transforms tibble in a new object, dplyr functions that operate on 
#this object know they have to operate separately per category
class(group_by(diamonds,cut))
summarize(group_by(diamonds,cut),mean(price))

##chaining using pipes
diamonds %>% select(carat,cut,price) %>% filter(cut=="Ideal" & price>400)
tbl %>% select(-Species) %>% map(mean) #Note that last function doesn't need any arguments
tbl %>% group_by(Species) %>% summarize_each(mean) #Applying mean over all rows for all Species classes

#####

### ggplot2

ggplot(data=mpg)+geom_point(mapping=aes(x=displ,y=hwy,color=class))

ggplot(data=mpg,mapping=aes(x=displ,y=hwy))+geom_point()+geom_smooth(method="lm")

ggplot(data=mpg,mapping=aes(x=displ,y=hwy))+geom_point()+facet_wrap(~class)

#barplots
ggplot(data=diamonds)+geom_bar(mapping=aes(x=cut,fill=color))+ggtitle("Histogram of diamond cuts")

  #geom_freqpoly() is a line equivalent of histograms, in which it can be easier to see differences
  #between classes (as overlapping will not be an issue).
ggplot(data=diamonds,mapping=aes(x=carat,color=cut))+geom_freqpoly(binwidth=0.1)

  #zooming in with coord_cartesian()
ggplot(data=diamonds,mapping=aes(x=carat,color=cut))+geom_freqpoly(binwidth=0.1)+coord_cartesian(ylim=c(0,50))

  #boxplots
ggplot(data=diamonds,aes(x=cut,y=carat))+geom_boxplot()
