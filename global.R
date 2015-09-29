library(dplyr)

# Source renderChart3.R
source('./renderChart3.R')

# Data loading, cleaning and processing
ratingps4 <- read.csv('./metacriticdata-ps4.txt', header = F)
ratingps4 <- ratingps4 %>% mutate(Platform='PS4')

ratingsxbone <- read.csv('./metacriticdata-xbone.txt', header = F)
ratingsxbone <- ratingsxbone %>% mutate(Platform='XBoxOne')

ratingswiiu <- read.csv('./metacriticdata-wiiu.txt', header = F)
ratingswiiu <- ratingswiiu %>% mutate(Platform='WiiU')

ratingspc <- read.csv('./metacriticdata-pc.txt', header = F)
ratingspc <- ratingspc %>% mutate(Platform='PC')

ratings <- rbind(ratingps4,ratingsxbone,ratingswiiu,ratingspc)

names(ratings) <- c('CriticRating', 'GameName', 'UserRating', 'Platform')

ratings <- ratings %>% mutate(CriticRating=round(CriticRating/10,2))
ratings <- ratings %>% filter(UserRating!='tbd')
ratings <- ratings %>% mutate(CriticRating=as.numeric(CriticRating), UserRating=as.numeric(UserRating))

platforms <- c('All',unique(ratings$Platform))

# Linear Models
lmRatings <- lm(CriticRating ~ UserRating, ratings)
lmRatingsByPlat <- lm(CriticRating ~ UserRating * Platform, ratings)