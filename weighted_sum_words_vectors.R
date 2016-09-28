#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# Libraries
library(tm)

# Dataset
ds_file <- args[1]
#ds_file <- "/home/phd/Dropbox/doutorado/data/datasets/short_text/n20_short.csv"
ds_df <- read.csv2(file = ds_file, header = F)
ds_df <- ds_df["V3"]

# Document x Term TF-IDF matrix
terms_tfidf <- as.matrix(
    DocumentTermMatrix(
        Corpus(DataframeSource(ds_df)),
        control = list(weighting = function(x) weightTfIdf(x, normalize = T))
    )
)

# Remove useless objects
rm(ds_df)
rm(ds_file)

# Words vectors
wv_file <- args[2]
#wv_file <- "/home/phd/Dropbox/doutorado/data/Vectors/newsN20short_vectors_glove.txt"
wv <- read.csv(file = wv_file, header = F, sep = " ")
wv <- as.matrix(wv[, !(names(wv) %in% c("V1"))])

# Remove useless objects
rm(wv_file)

# Documents vectors
dv <- terms_tfidf %*% wv

dv_file <- args[3]
#dv_file <- "/home/phd/Dropbox/doutorado/data/docs_vecs/newsN20short_docs-vecs_glove.csv"

# Save documents vectors to disk
write.table(x = dv, file = dv_file, sep = " ", row.names = F, col.names = F)
