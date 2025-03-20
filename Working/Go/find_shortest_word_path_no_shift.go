package main

import (
	"bufio"
	"fmt"
	"math/rand"
	"os"
	"strings"
	"time"
)

// PathResult holds the result of finding a word path
type PathResult struct {
	Possible bool
	Path     []string
	Steps    int
}

// QueueItem represents an item in the BFS queue
type QueueItem struct {
	word string
	path []string
}

// loadWordList reads words from a file
func loadWordList(filePath string) ([]string, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return nil, fmt.Errorf("could not open file %s: %v", filePath, err)
	}
	defer file.Close()

	var wordList []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		word := strings.TrimSpace(scanner.Text())
		wordList = append(wordList, word)
	}

	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("error reading file: %v", err)
	}

	fmt.Printf("Successfully loaded %d words from %s\n\n", len(wordList), filePath)
	return wordList, nil
}

// selectRandomWords picks two random words of specified length
func selectRandomWords(wordList []string, wordLength int) (string, string, error) {
	var validWords []string
	for _, word := range wordList {
		if len(word) == wordLength {
			validWords = append(validWords, word)
		}
	}

	if len(validWords) < 2 {
		return "", "", fmt.Errorf("not enough words of length %d", wordLength)
	}

	// Select two different random words
	rand.Seed(time.Now().UnixNano())
	idx1 := rand.Intn(len(validWords))
	idx2 := idx1
	for idx2 == idx1 {
		idx2 = rand.Intn(len(validWords))
	}

	startWord := validWords[idx1]
	targetWord := validWords[idx2]

	fmt.Println("Selected words:")
	fmt.Printf("  Start:  %s\n", startWord)
	fmt.Printf("  Target: %s\n\n", targetWord)

	return startWord, targetWord, nil
}

// findShortestWordPath finds the shortest path between two words
func findShortestWordPath(startWord, targetWord string, wordList []string) PathResult {
	// Early exit if words are the same
	if startWord == targetWord {
		return PathResult{
			Possible: true,
			Path:     []string{startWord},
			Steps:    0,
		}
	}

	// Convert list to map for O(1) lookups
	wordSet := make(map[string]bool)
	for _, word := range wordList {
		wordSet[word] = true
	}

	// Create queue and visited set
	queue := []QueueItem{{word: startWord, path: []string{startWord}}}
	visited := make(map[string]bool)
	visited[startWord] = true

	for len(queue) > 0 {
		// Pop first item from queue
		current := queue[0]
		queue = queue[1:]

		// Try changing each letter position
		wordRunes := []rune(current.word)
		for i := 0; i < len(wordRunes); i++ {
			originalChar := wordRunes[i]
			for c := 'A'; c <= 'Z'; c++ {
				wordRunes[i] = c
				newWord := string(wordRunes)

				if wordSet[newWord] && !visited[newWord] {
					if newWord == targetWord {
						// Found target word
						newPath := append(current.path, newWord)
						return PathResult{
							Possible: true,
							Path:     newPath,
							Steps:    len(current.path),
						}
					}

					// Add to queue and mark as visited
					newPath := make([]string, len(current.path))
					copy(newPath, current.path)
					queue = append(queue, QueueItem{
						word: newWord,
						path: append(newPath, newWord),
					})
					visited[newWord] = true
				}
			}
			wordRunes[i] = originalChar
		}
	}

	// No path found
	return PathResult{
		Possible: false,
		Path:     nil,
		Steps:    -1,
	}
}

func main() {
	// Load word list
	wordList, err := loadWordList("/home/chuck/Dropbox/Programming/Languages_and_Code/Programming_Projects/Games/Word_Games/Word Path Finder/Go/TWL4L.txt")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	// Select random words
	startWord, targetWord, err := selectRandomWords(wordList, 4)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	// Find path
	result := findShortestWordPath(startWord, targetWord, wordList)

	// Print result
	if result.Possible {
		fmt.Printf("Found path with %d steps: %s\n",
			result.Steps,
			strings.Join(result.Path, " -> "))
	} else {
		fmt.Printf("No path found between %s and %s\n",
			startWord, targetWord)
	}
}
