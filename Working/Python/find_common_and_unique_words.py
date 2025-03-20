def load_word_list(file_path: str) -> list:
    try:
        with open(file_path, 'r') as file:
            # Read all words, strip whitespace, make word list
            contents = file.read()
            words = contents.split()
            
        print(f"Successfully loaded {len(words)} 4-letter words from {file_path}")
        return words
        
    except FileNotFoundError:
        print(f"Error: Could not find file {file_path}")
        return []
    except Exception as e:
        print(f"Error reading file: {str(e)}")
        return []
    

# Create the common word file
if __name__ == "__main__":
    
    common_words = []
    unique_words = []
    
    swp_words = load_word_list('SOWPODS4.txt')
    twl_words = load_word_list('TWL4.txt')
    
    for word in swp_words:
        if word in twl_words:
            common_words.append(word)
        else:
            unique_words.append(word)
    
    print('There are ' + str(len(common_words)) + ' common words in both lists')
    print(common_words)
    print('There are ' + str(len(unique_words)) + ' unique words in both lists')
    print(unique_words)
    
    with open('COMMON.txt', 'w') as f:
    # Write the string to the file
        f.write(' '.join(common_words))
        
    with open('UNIQUE.txt', 'w') as f:
    # Write the string to the file
        f.write(' '.join(unique_words))



