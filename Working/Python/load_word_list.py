def load_word_list(file_path: str) -> list:
    try:
        with open(file_path, 'r') as file:
            # Read all words, strip whitespace, make word list
            contents = file.read()
            words = contents.split()
            
        print(f"Successfully loaded {len(words)} 4-letter words from {file_path}")
        print()
        return words
        
    except FileNotFoundError:
        print(f"Error: Could not find file {file_path}")
        return []
    except Exception as e:
        print(f"Error reading file: {str(e)}")
        return []
    
def write_word_list_to_file(file_path: str, word_list: list):
    with open(file_path, "w") as f:
        for word in word_list:
            f.write(word + "\r\n")