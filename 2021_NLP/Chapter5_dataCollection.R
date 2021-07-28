rm(list = ls())

library(tidyverse)
library(tidytext)
library(jsonlite)

tmdb <- read_csv("C:/Users/agilb/Downloads/tmdb.csv")
head(tmdb)

movies_genres <- tmdb %>%
  mutate(js = lapply(genres, fromJSON)) %>%
  select(id, title, js, overview) %>%
  unnest(js, .name_repair = "unique")

top_genre <- movies_genres %>%
  group_by(title) %>%
  slice(1) %>%
  ungroup()

primary_genre <- top_genre %>%
  select(name, overview) %>%
  rename(genre = name)
primary_genre

train_ind <- sample(1:nrow(primary_genre), floor(0.9*nrow(primary_genre)), replace = FALSE)
train_genre <- primary_genre[train_ind, ]
test_genre <- primary_genre[-train_ind, ]
test_overview <- test_genre$overview
test_genre <- test_genre$genre

write.csv(train_genre, "C:/Users/agilb/Documents/GitHub/FacultyUpskilling/2021_NLP/data/train.csv", row.names = FALSE)
write.csv(test_overview, "C:/Users/agilb/Documents/GitHub/FacultyUpskilling/2021_NLP/data/test.csv", row.names = FALSE)
write.csv(test_genre, "C:/Users/agilb/Documents/GitHub/FacultyUpskilling/2021_NLP/data/key.csv", row.names = FALSE)
