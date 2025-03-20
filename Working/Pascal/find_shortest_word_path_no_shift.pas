program WordPathFinder;

const
  MAX_WORD_LEN = 4;
  MAX_PATH_LEN = 100;
  MAX_QUEUE_SIZE = 10000;
  MAX_WORDS = 4180;

type
  TWord = string[MAX_WORD_LEN];
  TWordArray = array[1..MAX_WORDS] of TWord;
  TPath = array[0..MAX_PATH_LEN] of TWord;

  TPathResult = record
    possible: boolean;
    path: TPath;
    pathLength: integer;
    steps: integer;
  end;

  TQueueItem = record
    word: TWord;
    path: TPath;
    pathLength: integer;
  end;

  TQueue = array[1..MAX_QUEUE_SIZE] of TQueueItem;
  TVisited = array[1..MAX_QUEUE_SIZE] of TWord;

var
  wordList: TWordArray;
  wordCount: integer;


{ Load words from file }
procedure LoadWordList(const filePath: string);
var
  textFile: Text;
  nWord: string;
begin
  wordCount := 0;

  Assign(textFile, filePath);
  {$I-}
  Reset(textFile);
  {$I+}

  if IOResult <> 0 then
  begin
    WriteLn('Error: Could not open file ', filePath);
    Exit;
  end;

  while not Eof(textFile) do
  begin
    ReadLn(textFile, nWord);
    begin
      Inc(wordCount);
      wordList[wordCount] := nWord;
    end;
  end;

  Close(textFile);
  WriteLn('Successfully loaded ', wordCount, ' words from ', filePath);
  WriteLn;
end;

{ Select two random words of specified length }
procedure SelectRandomWords(wordLength: integer; var startWord, targetWord: TWord; var success: boolean);
var
  validIndices: array[1..MAX_WORDS] of integer;
  validCount, idx1, idx2, i: integer;
begin
  validCount := 0;
  success := false;

  { Find words of correct length }
  for i := 1 to wordCount do
    if Length(wordList[i]) = wordLength then
    begin
      Inc(validCount);
      validIndices[validCount] := i;
    end;

  if validCount < 2 then
  begin
    WriteLn('Error: Not enough words of length ', wordLength);
    Exit;
  end;

  { Select two different random words }
  idx1 := Random(validCount) + 1;
  repeat
    idx2 := Random(validCount) + 1;
  until idx1 <> idx2;

  startWord := wordList[validIndices[idx1]];
  targetWord := wordList[validIndices[idx2]];

  WriteLn('Selected words:');
  WriteLn('  Start:  ', startWord);
  WriteLn('  Target: ', targetWord);
  WriteLn;

  success := true;
end;

{ Find shortest path between words }
function FindShortestWordPath(const startWord, targetWord: TWord): TPathResult;
var
  queue: TQueue;
  visited: TVisited;
  queueSize, visitedSize: integer;
  currentWord, newWord: TWord;
  i, j, k: integer;
  newLetter: char;
  wordExists, isVisited: boolean;
  wordPath: string;
  Result: TPathResult;

begin
  { Early exit if words are the same }
  if startWord = targetWord then
  begin
    Result.possible := true;
    Result.pathLength := 1;
    Result.path[0] := startWord;
    Result.steps := 0;
    Exit;
  end;

  { Initialize queue with start word }
  queueSize := 1;
  visitedSize := 1;
  queue[1].word := startWord;
  queue[1].pathLength := 1;
  queue[1].path[0] := startWord;
  visited[1] := startWord;

  while queueSize > 0 do
  begin
    currentWord := queue[1].word;

    { Try changing each letter position }
    for i := 1 to Length(currentWord) do
      { Try each letter A-Z }
      for j := Ord('A') to Ord('Z') do
      begin
        newLetter := Chr(j);
        newWord := currentWord;
        newWord[i] := newLetter;

        newWord := newWord;
        currentWord := currentWord;

        { Check if word exists and not visited }
        wordExists := false;
        for k := 1 to wordCount do
          if wordList[k] = newWord then
          begin
            wordExists := true;
            Break;
          end;

        isVisited := false;
        for k := 1 to visitedSize do
          if visited[k] = newWord then
          begin
            isVisited := true;
            Break;
          end;

        if wordExists and not isVisited then
        begin
          { Check if target found }
          if newWord = targetWord then
          begin
            Result.possible := true;
            Result.pathLength := queue[1].pathLength + 1;
            for k := 0 to queue[1].pathLength - 1 do
              Result.path[k] := queue[1].path[k];
            Result.path[queue[1].pathLength] := newWord;
            Result.steps := queue[1].pathLength;
            WriteLn('Path Possible: ', Result.possible); // Debugging output
            WriteLn('Number of steps: ', Result.steps); // Debugging output
            for k := 0 to Result.pathLength - 2 do
              wordPath := wordPath + Result.path[k] + ' -> ';
            wordPath := wordPath + Result.path[Result.pathLength - 1];
            WriteLn('Word path:', wordPath); // Debugging output
            Exit;
          end;

          { Add to queue }
          Inc(queueSize);
          Inc(visitedSize);
          queue[queueSize].word := newWord;
          queue[queueSize].pathLength := queue[1].pathLength + 1;
          for k := 0 to queue[1].pathLength - 1 do
            queue[queueSize].path[k] := queue[1].path[k];
          queue[queueSize].path[queue[1].pathLength] := newWord;
          visited[visitedSize] := newWord;
        end;
      end;

    { Remove first item from queue }
    for i := 1 to queueSize - 1 do
      queue[i] := queue[i + 1];
    Dec(queueSize);
  end;

  { No path found }
  Result.possible := false;
  Result.pathLength := 0;
  Result.steps := -1;
  WriteLn('No path found'); // Debugging output
end;

{ Main program }
var
  startWord, targetWord: TWord;
  result: TPathResult;
  success: boolean;
  i: integer;
begin
  Randomize;  { Initialize random number generator }

  { Load word list }
  LoadWordList('TWL4L.txt');

  { Select random words }
  SelectRandomWords(4, startWord, targetWord, success);

  if success then
  begin
    { Find path }
    result := FindShortestWordPath(startWord, targetWord);
  end;
end.
