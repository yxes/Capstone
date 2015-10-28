library(data.table)

dat <- list()
current_context <- "news"

loadContext <- function(context = "news") {
   dat <<- list(words = readRDS(paste("dat/Rda/",context,"_wordlist.Rda", sep="")),
	       gram1 = readRDS(paste("dat/Rda/",context,"_1.Rda", sep="")),
	       gram2 = readRDS(paste("dat/Rda/",context,"_2.Rda", sep="")),
	       gram3 = readRDS(paste("dat/Rda/",context,"_3.Rda", sep="")),
	       gram4 = readRDS(paste("dat/Rda/",context,"_4.Rda", sep="")))
   setkey(dat$words)
   current_context <<- context
}
loadContext();

input_words <- function(input_string) {
    print(paste("incoming string:", input_string))
    # clean up string
    input_string <- gsub("\\d+",         "", input_string, perl = TRUE)
    input_string <- gsub("[^\\w\\s'#]+", "", input_string, perl = TRUE)
    input_string <- gsub("(['#])\\1", "\\1", input_string, perl = TRUE)
    input_string <- gsub("_+",           "", input_string, perl = TRUE)
    input_string <- gsub("\\s+",        " ", input_string, perl = TRUE)
    input_string <- tolower(input_string)

    #print(paste("cleaned string:", input_string))

    all_words <- unlist(strsplit(input_string, "\\s+"))

    # remove words we don't have in our dictionary
    words_idx <- vector(mode="list")
    for (num in length(all_words):1) {
	word_idx <- match(all_words[num], t(dat$words))
        print(paste("word idx:", word_idx, " -> ", all_words[num]))
        if (!is.na(word_idx)) words_idx <- c(word_idx, words_idx)
	if (length(words_idx) > 3) return(words_idx)
    }
    
return(words_idx) # last # words index of the string (we didn't get to 4)
}

nextWord <- function(input_string, context = "news") {
    if (current_context != context) loadContext(context)

    words_idx <- input_words(input_string)

    if (length(words_idx) == 0) return("the") # we have no words returned

### TEST INDEX
    for (idx in words_idx) {
	print(paste("IDX:", toString(dat$words[idx]$word)))
    }
###
    # search for that combo within the grams
    max_length <- length(words_idx)
    for (num in max_length:1) {
	# setup our gram table
	gram <- dat[[num + 1]]
	mycols <- head(colnames(gram), n=num)
	setkeyv(gram,mycols)

	# lookup key
	found <- tail(gram[words_idx]$p, n=1)
	#print(paste("final: ", dat$words[found]$word))
	print(paste("final idx: ", found))
	if (!is.na(found)) return(toString(dat$words[found]$word))

	# shift off the first word in the index
	if (length(words_idx) > 1) words_idx <- words_idx[2:num]        
    }

    return("the")
}

#print(paste("output:",nextWord("hEllo World")))
#print(paste("output:",nextWord("Ou812")))
#print(paste("output:",nextWord("To Be or Not To Be, that is the question", "blogs")))
#print(paste("output:",nextWord("I can't dance and I __ can't sing and i *know* everything!")))
#print(paste("output:",nextWord("wopesdx for the first")))
#print(paste("output:",nextWord("bulldog an amazing flavor and")))
#print(paste("output:",nextWord("fejad arjed ejads feas")))
#print(paste("output:",nextWord("I love the way he plays the game he's a great guy")))
#print(paste("news:", nextWord("spinach and", "news")))
#print(paste("blogs:", nextWord("spinach and","blogs")))
#print(paste("twitter:", nextWord("spinach and","twitter")))
