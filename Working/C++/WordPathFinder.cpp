#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <queue>
#include <unordered_set>
#include <string>
#include <random>
#include <chrono>

struct PathResult {
    bool possible;
    std::vector<std::string> path;
    int steps;
};

// Load words from file
std::vector<std::string> loadWordList(const std::string& filePath) {
    std::vector<std::string> wordList;
    std::ifstream file(filePath);
    std::string line, word;

    if (!file.is_open()) {
        std::cerr << "Error: Could not open file " << filePath << std::endl;
        return wordList;
    }

    std::getline(file, line);
    std::stringstream ss(line);

    while (getline(ss, word, ' ')) {
        wordList.push_back(word);
    }

    std::cout << "Successfully loaded " << wordList.size() << " words from "
              << filePath << std::endl << std::endl;

    return wordList;
}

// Select two random words of specified length
bool selectRandomWords(const std::vector<std::string>& wordList,
                      int wordLength,
                      std::string& startWord,
                      std::string& targetWord) {
    std::vector<std::string> validWords;

    // Find words of correct length
    for (const auto& word : wordList) {
        if (word.length() == static_cast<size_t>(wordLength)) {
            validWords.push_back(word);
        }
    }

    if (validWords.size() < 2) {
        std::cerr << "Error: Not enough words of length " << wordLength << std::endl;
        return false;
    }

    // Initialize random number generator
    auto seed = std::chrono::system_clock::now().time_since_epoch().count();
    std::mt19937 gen(seed);
    std::uniform_int_distribution<> dis(0, validWords.size() - 1);

    // Select two different random words
    int idx1 = dis(gen);
    int idx2;
    do {
        idx2 = dis(gen);
    } while (idx2 == idx1);

    startWord = validWords[idx1];
    targetWord = validWords[idx2];

    std::cout << "Selected words:" << std::endl;
    std::cout << "  Start:  " << startWord << std::endl;
    std::cout << "  Target: " << targetWord << std::endl << std::endl;

    return true;
}

// Find shortest path between words
PathResult findShortestWordPath(const std::string& startWord,
                               const std::string& targetWord,
                               const std::vector<std::string>& wordList) {
    PathResult result;

    // Early exit if words are the same
    if (startWord == targetWord) {
        result.possible = true;
        result.path = {startWord};
        result.steps = 0;
        return result;
    }

    // Convert list to set for O(1) lookups
    std::unordered_set<std::string> wordSet(wordList.begin(), wordList.end());

    // Queue will store pairs of {word, path}
    std::queue<std::pair<std::string, std::vector<std::string>>> queue;
    std::unordered_set<std::string> visited;

    // Initialize queue with start word
    queue.push({startWord, {startWord}});
    visited.insert(startWord);

    while (!queue.empty()) {
        auto [currentWord, currentPath] = queue.front();
        queue.pop();

        // Try changing each letter position
        for (size_t i = 0; i < currentWord.length(); ++i) {
            // Try each letter A-Z
            for (char c = 'A'; c <= 'Z'; ++c) {
                std::string newWord = currentWord;
                newWord[i] = c;

                // Check if word exists and not visited
                if (wordSet.count(newWord) && !visited.count(newWord)) {
                    // If we found target, return path
                    if (newWord == targetWord) {
                        result.possible = true;
                        result.path = currentPath;
                        result.path.push_back(newWord);
                        result.steps = currentPath.size();
                        return result;
                    }

                    // Add to queue and mark as visited
                    std::vector<std::string> newPath = currentPath;
                    newPath.push_back(newWord);
                    queue.push({newWord, newPath});
                    visited.insert(newWord);
                }
            }
        }
    }

    // No path found
    result.possible = false;
    result.path.clear();
    result.steps = -1;
    return result;
}

int main() {
    // Load word list
    auto wordList = loadWordList("TWL4.txt");
    if (wordList.empty()) return 1;

    // Select random words
    std::string startWord, targetWord;
    if (!selectRandomWords(wordList, 4, startWord, targetWord)) {
        return 1;
    }

    // Find path
    auto result = findShortestWordPath(startWord, targetWord, wordList);

    // Print result
    if (result.possible) {
        std::cout << "Found path with " << result.steps << " steps: ";
        for (size_t i = 0; i < result.path.size(); ++i) {
            if (i > 0) std::cout << " -> ";
            std::cout << result.path[i];
        }
        std::cout << std::endl;
    } else {
        std::cout << "No path found between " << startWord << " and "
                  << targetWord << std::endl;
    }

    return 0;
}
