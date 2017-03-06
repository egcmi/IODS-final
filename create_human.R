# Emanuela Giovanna Calabi
# 06.03.17
# emanuela.calabi@helsinki.fi
# Data wrangling for final assignment
# "Human Development Index", info: http://hdr.undp.org/en/content/human-development-index-hdi

library(dplyr)
library(stringr)

#Import data "Human development" and "Gender inequality"
HD <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = FALSE)
GI <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = FALSE, na.strings = "..")

# structure, dimension, summary of HD
str(HD)
dim(HD)
summary(HD)

# structure, dimension, summary of GI
str(GI)
dim(GI)
summary(GI)

# change HD variable names
colnames(HD)
colnames(HD)[1] <- "HDI.rank"
colnames(HD)[2] <- "country"
colnames(HD)[3] <- "HDI"
colnames(HD)[4] <- "life.exp"
colnames(HD)[5] <- "edu.exp"
colnames(HD)[6] <- "edu.mean"
colnames(HD)[7] <- "GNI"
colnames(HD)[8] <- "GNI.rank"
colnames(HD)

# change GI variable names
colnames(GI)
colnames(GI)[1] <- "GII.rank"
colnames(GI)[2] <- "country"
colnames(GI)[3] <- "GII"
colnames(GI)[4] <- "mat.mor"
colnames(GI)[5] <- "ado.birth"
colnames(GI)[6] <- "parl.f"
colnames(GI)[7] <- "edu2.f"
colnames(GI)[8] <- "edu2.m"
colnames(GI)[9] <- "lab.f"
colnames(GI)[10] <- "lab.m"
colnames(GI)

# new variables
GI <- mutate(GI, edu2.fm = edu2.f/edu2.m)
GI <- mutate(GI, lab.fm = lab.f/lab.m)

# join by country
human <- inner_join(HD, GI, by="country")

# choose columns to keep
## this has been changed from the data wrangling of weeks4-5, the variable parl.f has been removed as there wasn't much correlation to the other variables, instead the variable GII is kept.
keep <- c("country", "edu2.fm", "lab.fm", "life.exp", "edu.exp", "edu.mean", "GNI", "GII", "mat.mor", "ado.birth")
human <- select(human, one_of(keep))

# GNI to numeric
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

# only keep complete observations
human <- filter(human, complete.cases(human) == TRUE)

# check countries, remove last 7 observations (regions)
human$country
last <- nrow(human) - 7
human <- human[1:last, ]
dim(human)

# countries as rownames
rownames(human) <- human$country
human <- select(human, -country)

# final dataset
dim(human)
str(human)
summary(human)

# write human dataset to file
write.csv(human, "~/Desktop/IODS/IODS-final/human.txt", row.names=TRUE)
