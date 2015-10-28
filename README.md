# Capstone
## Coursera Data Science Specialization
### Dec 2015 Capstone Project Files

### Author: [Stephen D. Wells](http://www.stephendwells.com/)

### Live Demo: <https://yxes.shinyapps.io/Capstone/>
### Presentation: <http://rpubs.com/yxes/Capstone>
### Milestone Writeup: <https://rpubs.com/yxes/40858>

## SUMMARY

This was the result of trying to simulate and present a demo
of [SwiftKey](http://swiftkey.com/en) in under two months. It
was a project developed by Johns Hopkins in conjungtion with
Coursera as part of their 
[Data Science Specialization](https://www.coursera.org/specializations/jhudatascience)
coursework. The final presentation was to include a Shiny
Application that predicted the next word given the context of 
the previous words.

## HEADLINES

* Uses Markov n-grams with backoff prediction
* built from 100M Words
* Datasets derived from the Internet
* Special Datasets predict from News, Blogs and Twitter Feeds
* Custom compression algorithm - tiny amount of RAM

## PROCESS

I used perl to preprocess and reformat the data into something that 
I was able to load into R very quickly. The counts for the most 
common words were processed with perl (the source is included within
the data directory). It took hours (of heart wrenching worry) to preprocess,
but in the end delievered 1-4 n-grams of each dataset. These are then
loaded in R and used for the prediction algorithm. If you spend the time
formatting and optimizing your data you can end up with very fast
and suprisingly accurate results.

## DATA SOURCES

The data was provided by SwiftKey as part of the project.
