import random
import load_word_list as lwl
import find_shortest_word_path_no_shift as fswpns
import find_shortest_word_path_with_shift as fswps
import run_shortest_word_path_comparison as rswpc


# Run the tests
if __name__ == "__main__":

    # Load the word list
    #words = lwl.load_word_list("TWL4.txt")
    words = lwl.load_word_list("SOWPODS4.txt")

    # Set random seed for reproducibility
    random.seed(random.randint(0, 100))

    # Get random start and target words for a single test
    start_word, target_word = random.sample(words, 2)
    print("Starting single path test with no shifts...")
    print(f"Start word: {start_word}, Target word: {target_word}")
    result = fswpns.find_shortest_word_path_no_shift(start_word,
                                                     target_word, words)
    print(f"Possible: {result['possible']}")
    print(f"Path: {result['path']}")
    print(f"Steps: {result['steps']}")
    print()

    print("Starting single path test with shifts...")
    print(f"Start word: {start_word}, Target word: {target_word}")
    result = fswps.find_shortest_word_path_with_shift(start_word,
                                                      target_word,
                                                      words)
    print(f"Possible: {result['possible']}")
    print(f"Path: {result['path']}")
    print(f"Steps: {result['steps']}")
    print()

    # Run shortest path comparison
    print("Starting comparison tests...")
    print(f"Total words in dictionary: {len(words)}")
    rswpc.run_shortest_word_path_comparison_tests(words)
    print()
