def find_shortest_word_path_with_shift(start_word: str, target_word: str, word_list: list) -> dict:
    """
    Find shortest path between words by:
    1. Changing one letter at a time
    2. Shifting letters left/right and inserting a new letter
    
    Args:
        start_word: Starting 4-letter word
        target_word: Target 4-letter word
        word_list: List of valid 4-letter words
        
    Returns:
        Dictionary containing:
        - possible: Boolean indicating if path exists
        - path: List of words in the path
        - steps: Number of steps needed (-1 if impossible)
    """
    
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
        
        # Try all possible transformations
        possible_next_words = set()
        
        # 1. Traditional one-letter changes
        for i in range(len(current_word)):
            for j in range(65, 91):  # ASCII values for A-Z
                new_letter = chr(j)
                new_word = current_word[:i] + new_letter + current_word[i+1:]
                possible_next_words.add(new_word)
        
        # 2. Shift left and insert new letter at end
        shifted_left = current_word[1:] 
        for j in range(65, 91):
            new_word = shifted_left + chr(j)
            possible_next_words.add(new_word)
            
        # 3. Shift right and insert new letter at start
        shifted_right = current_word[:-1]
        for j in range(65, 91):
            new_word = chr(j) + shifted_right
            possible_next_words.add(new_word)
        
        # Check all possible next words
        for new_word in possible_next_words:
            if new_word in word_set and new_word not in visited:
                if new_word == target_word:
                    return {
                        "possible": True,
                        "path": current_path + [new_word],
                        "steps": len(current_path)
                    }
                
                queue.append((new_word, current_path + [new_word]))
                visited.add(new_word)
    
    # No path found
    return {
        "possible": False,
        "path": [],
        "steps": -1
    }