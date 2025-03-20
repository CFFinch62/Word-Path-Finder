program LoadWords;

type TStringArray = array of string;

{ Load words from file }
procedure LoadWordList(const filePath: string);

var
  wordList: TStringArray;
  wordCount: integer;
  textFile: Text;
  word: string;

begin
  wordCount := 0;
  SetLength(wordList, 4180);

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
    ReadLn(textFile, word);
    begin
      Inc(wordCount);
      wordList[wordCount] := word;
    end;
  end;

  Close(textFile);
  WriteLn('Successfully loaded ', wordCount, ' words from ', filePath);
  WriteLn;
end;

{ Main program }

begin

  { Load word list }
  LoadWordList('TWL4L.txt');

end.