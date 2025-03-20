def find_shortest_word_path_no_shift(start_word: str, target_word: str, word_list: list) -> dict:
    
    # Early exit if words are the same
    if start_word == target_word:
        return {
            "possible": True,
            "path": [start_word],
            "steps": 0
        }
    
    # Convert list to set for O(1) lookups
    word_set = set(word_list)
    
    # Queue will store tuples of (word, path)
    queue = [(start_word, [start_word])]
    visited = {start_word}
    
    while queue:
        current_word, current_path = queue.pop(0)
        
        # Try changing each letter position
        for i in range(len(current_word)):
            # Try each letter of the alphabet
            for j in range(65, 91):  # ASCII values for A-Z
                new_letter = chr(j)
                new_word = current_word[:i] + new_letter + current_word[i+1:]
                
                # Check if new word is valid and not visited
                if new_word in word_set and new_word not in visited:
                    # If we found target, return path
                    if new_word == target_word:
                        return {
                            "possible": True,
                            "path": current_path + [new_word],
                            "steps": len(current_path)
                        }
                    
                    # Add to queue and mark as visited
                    queue.append((new_word, current_path + [new_word]))
                    visited.add(new_word)
    
    # No path found
    return {
        "possible": False,
        "path": [],
        "steps": -1
    }