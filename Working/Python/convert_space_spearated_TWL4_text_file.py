os_type = input('Which OS are you converting the file for?\n Enter L for Linux/MacOS or W for Windows: ')
file_name = input('Type name of the file you wish converted(.txt extension assumed): ')
print()

input_file_name = file_name + '.txt'


if os_type == 'L' or os_type == 'l':
    output_file_name = file_name + 'LF.txt'
elif os_type == 'W' or os_type == 'w':
    output_file_name = file_name + 'CRLF.txt'
else:
    print('OS type unknown! Aborting.')
    exit

# open the file in read mode
with open(input_file_name, "r") as file:
    line = file.readline()

# convert line string into a list of words
word_list = line.split(" ")

print(f"Number of words read in from {input_file_name}:", len(word_list))
print()

# initialize word count
word_count = 0


# Open the file in write mode
with open(output_file_name, "w") as f:
    # Iterate over the list and write each item to the file
    for word in word_list:
        f.write(word + "\n")
        word_count +=1

print(f"Number of words written to {output_file_name}: {word_count}")
