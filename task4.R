# Load necessary libraries
library(dplyr)
library(tm)
library(syuzhet)
library(wordcloud)

dataset_path <- "C:/Users/Abc/Downloads/archive/twitter_validation.csv"

# Read the dataset
twitter_data <- read.csv(dataset_path, stringsAsFactors = FALSE)

# Create a corpus from the text data
corpus <- Corpus(VectorSource(twitter_data$text))

# Preprocessing steps
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("en"))
corpus <- tm_map(corpus, stripWhitespace)

# Convert corpus to a plain character vector
text <- as.character(corpus)

# Perform sentiment analysis using syuzhet package
sentiment_scores <- get_nrc_sentiment(text)

# Check dimensions and structure of sentiment_scores
dim(sentiment_scores)
head(sentiment_scores)

# Convert sentiment_scores to numeric if necessary
sentiment_scores <- as.data.frame(sapply(sentiment_scores, as.numeric))

# Sum sentiment scores across categories
twitter_data$sentiment <- rowSums(sentiment_scores)

# Check the structure of twitter_data
str(twitter_data)


# Visualize sentiment distribution using barplot
sentiment_counts <- table(cut(twitter_data$sentiment, breaks = 3, labels = c("Negative", "Neutral", "Positive")))

barplot(sentiment_counts, main = "Sentiment Distribution", xlab = "Sentiment", ylab = "Count", col = "skyblue")

