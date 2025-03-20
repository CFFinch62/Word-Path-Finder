-- Load words from file
local function load_word_list(file_path)
    local words = {}
    
    -- Try to open file
    local file = io.open(file_path, "r")
    if not file then
        print(string.format("Error: Could not open file %s", file_path))
        return {}
    end
    
    -- Read all words
    for line in file:lines() do
      for word in line:gmatch("%S+") do
        table.insert(words, word)
      end
    end
    
    file:close()
    print(string.format("Successfully loaded %d words from %s\n", #words, file_path))
    return words
end

-- Select random words of specified length
local function select_random_words(word_list, word_length)
    -- Find valid words
    local valid_words = {}
    for _, word in ipairs(word_list) do
        if #word == word_length then
            table.insert(valid_words, word)
        end
    end
    
    if #valid_words < 2 then
        print(string.format("Error: Not enough words of length %d", word_length))
        return nil
    end
    
    -- Select two different random words
    math.randomseed(os.time())
    local idx1 = math.random(#valid_words)
    local idx2
    repeat
        idx2 = math.random(#valid_words)
    until idx2 ~= idx1
    
    local start_word = valid_words[idx1]
    local target_word = valid_words[idx2]
    
    print("Selected words:")
    print(string.format("  Start:  %s", start_word))
    print(string.format("  Target: %s\n", target_word))
    
    return start_word, target_word
end

-- Generate all possible one-letter variations of a word
local function generate_variations(word)
    local variations = {}
    
    for i = 1, #word do
        for c = string.byte('A'), string.byte('Z') do
            local new_word = string.sub(word, 1, i-1) .. 
                            string.char(c) .. 
                            string.sub(word, i+1)
            table.insert(variations, new_word)
        end
    end
    
    return variations
end

-- Convert list to set for O(1) lookups
local function list_to_set(list)
    local set = {}
    for _, v in ipairs(list) do
        set[v] = true
    end
    return set
end

-- Find shortest path between words using BFS
local function find_shortest_path(start_word, target_word, word_list)
    -- Early exit if words are the same
    if start_word == target_word then
        return {
            possible = true,
            path = {start_word},
            steps = 0
        }
    end
    
    -- Convert list to set for O(1) lookups
    local word_set = list_to_set(word_list)
    
    -- Create queue and visited set
    local queue = {}
    local visited = {[start_word] = true}
    
    -- Initialize queue with start word
    table.insert(queue, {
        word = start_word,
        path = {start_word}
    })
    
    while #queue > 0 do
        -- Pop first item from queue
        local current = table.remove(queue, 1)
        
        -- Try all possible variations
        for _, new_word in ipairs(generate_variations(current.word)) do
            if word_set[new_word] and not visited[new_word] then
                if new_word == target_word then
                    -- Found target word
                    local new_path = {}
                    for _, w in ipairs(current.path) do
                        table.insert(new_path, w)
                    end
                    table.insert(new_path, new_word)
                    
                    return {
                        possible = true,
                        path = new_path,
                        steps = #current.path
                    }
                end
                
                -- Add to queue and mark as visited
                local new_path = {}
                for _, w in ipairs(current.path) do
                    table.insert(new_path, w)
                end
                table.insert(new_path, new_word)
                
                table.insert(queue, {
                    word = new_word,
                    path = new_path
                })
                visited[new_word] = true
            end
        end
    end
    
    -- No path found
    return {
        possible = false,
        path = {},
        steps = -1
    }
end

-- Format path for display
local function format_path(path)
    return table.concat(path, " -> ")
end

-- Main program
local function main()
    -- Load word list
    --local word_list = load_word_list("TWL4.txt")
    local word_list = load_word_list("SOWPODS4.txt")
    if #word_list == 0 then
        os.exit(1)
    end
    
    -- Select random words
    local start_word, target_word = select_random_words(word_list, 4)
    if not start_word then
        os.exit(1)
    end
    
    -- Find path
    local result = find_shortest_path(start_word, target_word, word_list)
    
    -- Print result
    if result.possible then
        print(string.format("Found path with %d steps: %s",
                          result.steps,
                          format_path(result.path)))
    else
        print(string.format("No path found between %s and %s",
                          start_word, target_word))
    end
end

-- Run main program
main() 