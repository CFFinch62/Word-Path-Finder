library(stringr)
library(purrr)

# Load words from file
load_word_list <- function(file_path) {
  tryCatch({
    # Read all words
    line <- readLines(file_path)
    words <- strsplit(line,"[[:space]]")
    
    cat(sprintf("Successfully loaded %d words from %s\n\n", 
                length(words), file_path))
    words
  }, error = function(e) {
    cat(sprintf("Error: Could not load word list from %s\n", file_path))
    cat(e$message, "\n")
    character(0)
  })
}

# Select random words of specified length
select_random_words <- function(word_list, word_length) {
  # Find valid words
  valid_words <- word_list[nchar(word_list) == word_length]
  
  if (length(valid_words) < 2) {
    cat(sprintf("Error: Not enough words of length %d\n", word_length))
    return(NULL)
  }
  
  # Select two different random words
  idx <- sample(length(valid_words), 2)
  start_word <- valid_words[idx[1]]
  target_word <- valid_words[idx[2]]
  
  cat("Selected words:\n")
  cat(sprintf("  Start:  %s\n", start_word))
  cat(sprintf("  Target: %s\n\n", target_word))
  
  list(start = start_word, target = target_word)
}

# Generate all possible one-letter variations
generate_variations <- function(word) {
  # Split word into characters
  chars <- str_split(word, "")[[1]]
  
  # Generate variations for each position
  variations <- map(seq_along(chars), function(i) {
    new_chars <- map_chr(LETTERS, function(letter) {
      temp <- chars
      temp[i] <- letter
      paste(temp, collapse = "")
    })
    new_chars
  })
  
  # Combine all variations
  unlist(variations)
}

# Queue class for BFS
Queue <- R6::R6Class(
  "Queue",
  public = list(
    items = list(),
    enqueue = function(item) {
      self$items[[length(self$items) + 1]] <- item
    },
    dequeue = function() {
      if (length(self$items) == 0) return(NULL)
      item <- self$items[[1]]
      self$items <- self$items[-1]
      item
    },
    is_empty = function() {
      length(self$items) == 0
    }
  )
)

# Find shortest path between words using BFS
find_shortest_path <- function(start_word, target_word, word_list) {
  # Early exit if words are the same
  if (start_word == target_word) {
    cat(sprintf("Found path with 0 steps: %s\n", start_word))
    return(list(
      possible = TRUE,
      path = c(start_word),
      steps = 0
    ))
  }
  
  # Convert list to set for O(1) lookups
  word_set <- set::set(word_list)
  
  # Create queue and visited set
  queue <- Queue$new()
  queue$enqueue(list(word = start_word, path = c(start_word)))
  visited <- set::set(start_word)
  
  while (!queue$is_empty()) {
    current <- queue$dequeue()
    
    # Try all possible variations
    variations <- generate_variations(current$word)
    
    # Filter valid variations
    valid_variations <- variations[variations %in% word_set & 
                                 !(variations %in% visited)]
    
    for (new_word in valid_variations) {
      if (new_word == target_word) {
        # Found target word
        final_path <- c(current$path, new_word)
        cat(sprintf("Found path with %d steps: %s\n",
                   length(current$path),
                   paste(final_path, collapse = " -> ")))
        return(list(
          possible = TRUE,
          path = final_path,
          steps = length(current$path)
        ))
      }
      
      # Add to queue and mark as visited
      queue$enqueue(list(
        word = new_word,
        path = c(current$path, new_word)
      ))
      visited$add(new_word)
    }
  }
  
  # No path found
  cat(sprintf("No path found between %s and %s\n", 
              start_word, target_word))
  list(
    possible = FALSE,
    path = character(0),
    steps = -1
  )
}

# Main program
main <- function() {
  # Load word list
  word_list <- load_word_list("TWL4.txt")
  if (length(word_list) == 0) {
    quit(status = 1)
  }
  
  # Select random words
  words <- select_random_words(word_list, 4)
  if (is.null(words)) {
    quit(status = 1)
  }
  
  # Find path
  find_shortest_path(words$start, words$target, word_list)
}

# Run main program
if (!interactive()) {
  main()
} 