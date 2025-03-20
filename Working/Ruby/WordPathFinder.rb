require 'set'

def find_shortest_word_path_no_shift(start_word, target_word, word_list)
  # Early exit if words are the same
  if start_word == target_word
    return {
      possible: true,
      path: [start_word],
      steps: 0
    }
  end

  # Convert list to set for O(1) lookups
  word_set = word_list.to_set

  # Queue will store tuples of [word, path]
  queue = [[start_word, [start_word]]]
  visited = Set.new([start_word])

  while !queue.empty?
    current_word, current_path = queue.shift

    # Try changing each letter position
    current_word.length.times do |i|
      # Try each letter of the alphabet
      ('A'..'Z').each do |new_letter|
        new_word = current_word.dup
        new_word[i] = new_letter

        # Check if new word is valid and not visited
        if word_set.include?(new_word) && !visited.include?(new_word)
          # If we found target, return path
          if new_word == target_word
            return {
              possible: true,
              path: current_path + [new_word],
              steps: current_path.length
            }
          end

          # Add to queue and mark as visited
          queue.push([new_word, current_path + [new_word]])
          visited.add(new_word)
        end
      end
    end
  end

  # No path found
  {
    possible: false,
    path: [],
    steps: -1
  }
end

def load_word_list(file_path)
  begin
    # Read all words from file
    words = File.read(file_path).split

    puts "Successfully loaded #{words.length} words from #{file_path}"
    puts

    words
  rescue Errno::ENOENT
    puts "Error: Could not find file #{file_path}"
    []
  rescue StandardError => e
    puts "Error reading file: #{e.message}"
    []
  end
end

def select_random_words(word_list)

  # Select two different random words
  start_word = word_list.sample
  target_word = word_list.sample

  # Make sure we don't get the same word
  while target_word == start_word
    target_word = word_list.sample
  end

  puts "Selected words:"
  puts "  Start:  #{start_word}"
  puts "  Target: #{target_word}"
  puts

  return start_word, target_word
end

# Update the example usage
word_list = load_word_list("TWL4.txt")
start_word, target_word = select_random_words(word_list)

if start_word && target_word
  result = find_shortest_word_path_no_shift(start_word, target_word, word_list)

  if result[:possible]
    puts "Found path with #{result[:steps]} steps:"
    puts result[:path].join(" -> ")
  else
    puts "No path found between #{start_word} and #{target_word}"
  end
end
