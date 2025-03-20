from typing import List, Tuple
import random
import statistics
from tqdm import tqdm
import find_shortest_word_path_no_shift as fswpns
import find_shortest_word_path_with_shift as fswps

def run_shortest_word_path_comparison_tests(word_list: List[str], num_tests: int = 1000) -> None:
    """
    Run comparison tests between the two word path finding algorithms.
    
    Args:
        word_list: List of valid 4-letter words
        num_tests: Number of tests to run (default 1000)
    """
    # Results storage
    no_shift_results = {
        "possible": 0,
        "impossible": 0,
        "steps": [],
        "max_steps": float('-inf'),
        "min_steps": float('inf'),
        "max_path": None,
        "min_path": None
    }
    
    shift_results = {
        "possible": 0,
        "impossible": 0,
        "steps": [],
        "max_steps": float('-inf'),
        "min_steps": float('inf'),
        "max_path": None,
        "min_path": None
    }
    
    # Run tests
    for _ in tqdm(range(num_tests), desc="Running tests"):
        # Get random words
        start_word, target_word = random.sample(word_list, 2)
        
        # Test no-shift version
        no_shift_result = fswpns.find_shortest_word_path_no_shift(start_word, target_word, word_list)
        if no_shift_result["possible"]:
            no_shift_results["possible"] += 1
            steps = no_shift_result["steps"]
            no_shift_results["steps"].append(steps)
            
            # Update max/min steps
            if steps > no_shift_results["max_steps"]:
                no_shift_results["max_steps"] = steps
                no_shift_results["max_path"] = (start_word, target_word, no_shift_result["path"])
            if steps < no_shift_results["min_steps"]:
                no_shift_results["min_steps"] = steps
                no_shift_results["min_path"] = (start_word, target_word, no_shift_result["path"])
        else:
            no_shift_results["impossible"] += 1
            
        # Test shift version
        shift_result = fswps.find_shortest_word_path_with_shift(start_word, target_word, word_list)
        if shift_result["possible"]:
            shift_results["possible"] += 1
            steps = shift_result["steps"]
            shift_results["steps"].append(steps)
            
            # Update max/min steps
            if steps > shift_results["max_steps"]:
                shift_results["max_steps"] = steps
                shift_results["max_path"] = (start_word, target_word, shift_result["path"])
            if steps < shift_results["min_steps"]:
                shift_results["min_steps"] = steps
                shift_results["min_path"] = (start_word, target_word, shift_result["path"])
        else:
            shift_results["impossible"] += 1
    
    # Calculate averages
    no_shift_avg = statistics.mean(no_shift_results["steps"]) if no_shift_results["steps"] else 0
    shift_avg = statistics.mean(shift_results["steps"]) if shift_results["steps"] else 0
    
    # Print results
    print("\nResults after", num_tests, "tests:")
    
    print("\nNo Shift Algorithm:")
    print(f"Possible paths: {no_shift_results['possible']}")
    print(f"Impossible paths: {no_shift_results['impossible']}")
    print(f"Average steps when possible: {no_shift_avg:.2f}")
    if no_shift_results["possible"] > 0:
        print(f"Maximum steps: {no_shift_results['max_steps']}")
        print("Maximum steps example:")
        start, target, path = no_shift_results["max_path"]
        print(f"{start} → {target}: {' → '.join(path)}")
        print(f"Minimum steps: {no_shift_results['min_steps']}")
        print("Minimum steps example:")
        start, target, path = no_shift_results["min_path"]
        print(f"{start} → {target}: {' → '.join(path)}")
    
    print("\nWith Shift Algorithm:")
    print(f"Possible paths: {shift_results['possible']}")
    print(f"Impossible paths: {shift_results['impossible']}")
    print(f"Average steps when possible: {shift_avg:.2f}")
    if shift_results["possible"] > 0:
        print(f"Maximum steps: {shift_results['max_steps']}")
        print("Maximum steps example:")
        start, target, path = shift_results["max_path"]
        print(f"{start} → {target}: {' → '.join(path)}")
        print(f"Minimum steps: {shift_results['min_steps']}")
        print("Minimum steps example:")
        start, target, path = shift_results["min_path"]
        print(f"{start} → {target}: {' → '.join(path)}")
    
    # Print comparison
    print("\nComparison:")
    print(f"Difference in possible solutions: {shift_results['possible'] - no_shift_results['possible']}")
    print(f"Average step difference: {shift_avg - no_shift_avg:.2f}")