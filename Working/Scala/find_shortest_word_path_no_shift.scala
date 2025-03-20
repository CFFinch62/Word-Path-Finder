import scala.io.Source
import scala.util.{Try, Success, Failure}
import scala.collection.mutable
import scala.util.Random

// Case classes for results and queue items
case class PathResult(
  possible: Boolean,
  path: List[String],
  steps: Int
)

case class QueueItem(
  word: String,
  path: List[String]
)

object WordPathFinder {
  // Load words from file
  def loadWordList(filePath: String): List[String] = {
    Try {
      val source = Source.fromFile(filePath)
      try {
        val words = source.getLines()
          .map(_.trim)
          .toList
        
        println(s"Successfully loaded ${words.length} words from $filePath\n")
        words
      } finally {
        source.close()
      }
    } match {
      case Success(words) => words
      case Failure(e) => 
        println(s"Error: Could not load word list from $filePath")
        println(e.getMessage)
        List.empty
    }
  }

  // Select random words of specified length
  def selectRandomWords(
    wordList: List[String], 
    wordLength: Int
  ): Option[(String, String)] = {
    val validWords = wordList.filter(_.length == wordLength)
    
    if (validWords.length < 2) {
      println(s"Error: Not enough words of length $wordLength")
      None
    } else {
      val idx1 = Random.nextInt(validWords.length)
      val idx2 = Iterator.continually(Random.nextInt(validWords.length))
        .dropWhile(_ == idx1)
        .next()
      
      val startWord = validWords(idx1)
      val targetWord = validWords(idx2)
      
      println("Selected words:")
      println(s"  Start:  $startWord")
      println(s"  Target: $targetWord\n")
      
      Some((startWord, targetWord))
    }
  }

  // Generate all possible one-letter variations of a word
  def generateVariations(word: String): Iterator[String] = {
    for {
      i <- word.indices.iterator
      c <- 'A' to 'Z'
    } yield word.updated(i, c)
  }

  // Find shortest path between words using BFS
  def findShortestPath(
    startWord: String,
    targetWord: String,
    wordList: List[String]
  ): PathResult = {
    // Early exit if words are the same
    if (startWord == targetWord) {
      return PathResult(true, List(startWord), 0)
    }

    // Convert list to set for O(1) lookups
    val wordSet = wordList.toSet
    
    // Create queue and visited set
    val queue = mutable.Queue(QueueItem(startWord, List(startWord)))
    val visited = mutable.Set(startWord)

    while (queue.nonEmpty) {
      val current = queue.dequeue()

      // Try all possible variations
      val variations = generateVariations(current.word)
        .filter(w => wordSet(w) && !visited(w))
      
      for (newWord <- variations) {
        if (newWord == targetWord) {
          // Found target word
          return PathResult(
            possible = true,
            path = current.path :+ newWord,
            steps = current.path.length
          )
        }

        // Add to queue and mark as visited
        queue.enqueue(QueueItem(newWord, current.path :+ newWord))
        visited.add(newWord)
      }
    }

    // No path found
    PathResult(false, List.empty, -1)
  }

  def main(args: Array[String]): Unit = {
    // Load word list
    val wordList = loadWordList("TWL4L.txt")
    if (wordList.isEmpty) {
      System.exit(1)
    }

    // Select random words
    selectRandomWords(wordList, 4) match {
      case None => 
        System.exit(1)
      
      case Some((startWord, targetWord)) =>
        // Find path
        val result = findShortestPath(startWord, targetWord, wordList)

        // Print result
        if (result.possible) {
          println(s"Found path with ${result.steps} steps: ${result.path.mkString(" -> ")}")
        } else {
          println(s"No path found between $startWord and $targetWord")
        }
    }
  }
} 