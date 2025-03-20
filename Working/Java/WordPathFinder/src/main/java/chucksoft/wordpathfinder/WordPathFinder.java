package chucksoft.wordpathfinder;

import java.io.*;
import java.util.*;

public class WordPathFinder {
    // Result class to hold path finding results
    static class PathResult {
        boolean possible;
        List<String> path;
        int steps;

        PathResult(boolean possible, List<String> path, int steps) {
            this.possible = possible;
            this.path = path;
            this.steps = steps;
        }
    }

    // Queue item class for BFS
    static class QueueItem {
        String word;
        List<String> path;

        QueueItem(String word, List<String> path) {
            this.word = word;
            this.path = path;
        }
    }

    // Load words from file
    private static List<String> loadWordList(String filePath) {
        List<String> wordList = new ArrayList<>();
        
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            
            while ((line = reader.readLine()) != null) {
                String[] words = line.split("[\\s]");
                wordList.addAll(Arrays.asList(words));
            }
            
            System.out.printf("Successfully loaded %d words from %s%n%n", 
                            wordList.size(), filePath);
            
        } catch (IOException e) {
            System.err.println("Error: Could not load word list from " + filePath);
            System.err.println(e.getMessage());
            System.exit(1);
        }
        
        return wordList;
    }

    // Select random words of specified length
    private static String[] selectRandomWords(List<String> wordList, int wordLength) {
        List<String> validWords = wordList.stream()
            .filter(word -> word.length() == wordLength)
            .toList();

        if (validWords.size() < 2) {
            System.err.printf("Error: Not enough words of length %d%n", wordLength);
            return null;
        }

        Random rand = new Random();
        int idx1 = rand.nextInt(validWords.size());
        int idx2;
        do {
            idx2 = rand.nextInt(validWords.size());
        } while (idx2 == idx1);

        String startWord = validWords.get(idx1);
        String targetWord = validWords.get(idx2);

        System.out.println("Selected words:");
        System.out.println("  Start:  " + startWord);
        System.out.println("  Target: " + targetWord);
        System.out.println();

        return new String[]{startWord, targetWord};
    }

    // Generate all possible one-letter variations of a word
    private static List<String> generateVariations(String word) {
        List<String> variations = new ArrayList<>();
        char[] wordChars = word.toCharArray();

        for (int i = 0; i < word.length(); i++) {
            char original = wordChars[i];
            for (char c = 'A'; c <= 'Z'; c++) {
                wordChars[i] = c;
                variations.add(new String(wordChars));
            }
            wordChars[i] = original;
        }

        return variations;
    }

    // Find shortest path between words using BFS
    private static PathResult findShortestPath(String startWord, 
                                             String targetWord, 
                                             List<String> wordList) {
        // Early exit if words are the same
        if (startWord.equals(targetWord)) {
            return new PathResult(true, 
                                List.of(startWord), 
                                0);
        }

        // Convert list to set for O(1) lookups
        Set<String> wordSet = new HashSet<>(wordList);
        
        // Create queue and visited set
        Queue<QueueItem> queue = new LinkedList<>();
        Set<String> visited = new HashSet<>();
        
        // Initialize queue with start word
        queue.offer(new QueueItem(startWord, List.of(startWord)));
        visited.add(startWord);

        while (!queue.isEmpty()) {
            QueueItem current = queue.poll();

            // Try all possible variations
            for (String newWord : generateVariations(current.word)) {
                if (wordSet.contains(newWord) && !visited.contains(newWord)) {
                    if (newWord.equals(targetWord)) {
                        // Found target word
                        List<String> newPath = new ArrayList<>(current.path);
                        newPath.add(newWord);
                        return new PathResult(true, 
                                           newPath, 
                                           current.path.size());
                    }

                    // Add to queue and mark as visited
                    List<String> newPath = new ArrayList<>(current.path);
                    newPath.add(newWord);
                    queue.offer(new QueueItem(newWord, newPath));
                    visited.add(newWord);
                }
            }
        }

        // No path found
        return new PathResult(false, 
                            Collections.emptyList(), 
                            -1);
    }

    public static void main(String[] args) {
        // Load word list
        List<String> wordList = loadWordList("TWL4CRLF.txt");

        // Select random words
        String[] words = selectRandomWords(wordList, 4);
        if (words == null) {
            System.exit(1);
        }

        // Find path
        PathResult result = findShortestPath(words[0], words[1], wordList);

        // Print result
        if (result.possible) {
            System.out.printf("Found path with %d steps: %s%n",
                            result.steps,
                            String.join(" -> ", result.path));
        } else {
            System.out.printf("No path found between %s and %s%n",
                            words[0], words[1]);
        }
    }
} 
