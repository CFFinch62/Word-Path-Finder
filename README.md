# Word-Path-Finder
DFS (Depth First Search) routines in various languages to create a list words which are shortest path between 2 four letter words by only chnaging one letter at a time to create a new word.

I had to work on this routine for a word game I am developing. 
For practive and to remmeber seom of the syntax of the various languages I have used over the years I tried to make it work in a large set of langauges. 
Some I got to work and other I did not. 
The folders they are in are self explanitory. 
Most of the issues I had along the way are IO (file reading) related. 

Below is an example ouput of one of the programs I wrote.

Their are two algorithms. One only allows a letter to be reomved and then replaced with another to forma new word: WORD -> W_RD -> WARD
The other allows for 'shfts': FARM -> _ARM (shift left) ARM_ -> ARMY

I only worked on both using Python and Javscript (for my actual development project).
The other languages all implement the 'no_shifts' algorithm.

❯ python word_path_tests.py
Successfully loaded 5662 4-letter words from SOWPODS4.txt

Starting single path test with no shifts...
Start word: SETS, Target word: RURP
Possible: True
Path: ['SETS', 'BETS', 'BUTS', 'BURS', 'BURP', 'RURP']
Steps: 5

Starting single path test with shifts...
Start word: SETS, Target word: RURP
Possible: True
Path: ['SETS', 'SESS', 'USES', 'URES', 'URPS', 'RURP']
Steps: 5

Starting comparison tests...
Total words in dictionary: 5662
Running tests: 100%|████████████████████████████████████████████████████████████| 1000/1000 [01:23<00:00, 11.99it/s]

Results after 1000 tests:

No Shift Algorithm:
Possible paths: 976
Impossible paths: 24
Average steps when possible: 4.91
Maximum steps: 10
Maximum steps example:
IXIA → KUFI: IXIA → ILIA → GLIA → GLID → GAID → KAID → KAIS → KATS → KATI → KUTI → KUFI
Minimum steps: 1
Minimum steps example:
HECK → HACK: HECK → HACK

With Shift Algorithm:
Possible paths: 989
Impossible paths: 11
Average steps when possible: 4.28
Maximum steps: 8
Maximum steps example:
FALX → ULNA: FALX → FAUX → FAUR → FOUR → OURS → URSA → URVA → ULVA → ULNA
Minimum steps: 1
Minimum steps example:
HECK → HACK: HECK → HACK

Comparison:
Difference in possible solutions: 13
Average step difference: -0.63
