Attribute VB_Name = "word_path"
' Find shortest word path without letter shifting
' Returns a custom type containing the result
Type WordPathResult
    Possible As Boolean
    Path() As String
    Steps As Long
End Type

' Queue will store words and their paths
Type QueueItem
    Word As String
    Path() As String
End Type

Public Function FindShortestWordPath(ByVal StartWord As String, _
                                   ByVal TargetWord As String, _
                                   ByRef WordList() As String) As WordPathResult
    
    Dim Result As WordPathResult
    
    ' Early exit if words are the same
    If StartWord = TargetWord Then
        ReDim Result.Path(0)
        Result.Path(0) = StartWord
        Result.Possible = True
        Result.Steps = 0
        FindShortestWordPath = Result
        Exit Function
    End If
    
    Dim Queue() As QueueItem
    ReDim Queue(0)
    
    ' Initialize first queue item
    ReDim Queue(0).Path(0)
    Queue(0).Word = StartWord
    Queue(0).Path(0) = StartWord
    
    ' Track visited words
    Dim Visited As Collection
    Set Visited = New Collection
    
    On Error Resume Next ' For collection key checks
    Visited.Add StartWord, StartWord
    On Error GoTo 0
    
    Dim QueueSize As Long
    QueueSize = 1
    
    Do While QueueSize > 0
        Dim CurrentWord As String
        Dim CurrentPath() As String
        
        CurrentWord = Queue(0).Word
        CurrentPath = Queue(0).Path
        
        ' Try changing each letter position
        Dim i As Long
        For i = 1 To Len(CurrentWord)
            ' Try each letter of the alphabet
            Dim j As Long
            For j = 65 To 90 ' ASCII values for A-Z
                Dim NewLetter As String
                NewLetter = Chr$(j)
                
                ' Build new word
                Dim NewWord As String
                NewWord = Left$(CurrentWord, i - 1) & NewLetter & _
                         Mid$(CurrentWord, i + 1)
                
                ' Check if word exists in WordList
                Dim WordExists As Boolean
                WordExists = IsWordInList(NewWord, WordList)
                
                ' Check if word was visited
                Dim IsVisited As Boolean
                On Error Resume Next
                Visited.Item NewWord
                IsVisited = (Err.Number = 0)
                On Error GoTo 0
                
                If WordExists And Not IsVisited Then
                    ' If we found target, return path
                    If NewWord = TargetWord Then
                        ReDim Result.Path(UBound(CurrentPath) + 1)
                        Dim k As Long
                        For k = 0 To UBound(CurrentPath)
                            Result.Path(k) = CurrentPath(k)
                        Next k
                        Result.Path(UBound(Result.Path)) = NewWord
                        Result.Possible = True
                        Result.Steps = UBound(CurrentPath)
                        FindShortestWordPath = Result
                        Exit Function
                    End If
                    
                    ' Add to queue
                    QueueSize = QueueSize + 1
                    ReDim Preserve Queue(QueueSize - 1)
                    
                    ReDim Queue(QueueSize - 1).Path(UBound(CurrentPath) + 1)
                    For k = 0 To UBound(CurrentPath)
                        Queue(QueueSize - 1).Path(k) = CurrentPath(k)
                    Next k
                    Queue(QueueSize - 1).Path(UBound(CurrentPath) + 1) = NewWord
                    Queue(QueueSize - 1).Word = NewWord
                    
                    ' Mark as visited
                    Visited.Add NewWord, NewWord
                End If
            Next j
        Next i
        
        ' Remove first item from queue by shifting everything left
        If QueueSize > 1 Then
            For i = 0 To QueueSize - 2
                Queue(i) = Queue(i + 1)
            Next i
        End If
        QueueSize = QueueSize - 1
        ReDim Preserve Queue(QueueSize - 1)
    Loop
    
    ' No path found
    ReDim Result.Path(-1)
    Result.Possible = False
    Result.Steps = -1
    
    FindShortestWordPath = Result
    
End Function

' Helper function to check if word exists in word list
Public Function IsWordInList(ByVal Word As String, _
                            ByRef WordList() As String) As Boolean
    Dim i As Long
    For i = LBound(WordList) To UBound(WordList)
        If WordList(i) = Word Then
            IsWordInList = True
            Exit Function
        End If
    Next i
    IsWordInList = False
End Function

' Load words from TWL4.txt file into an array
Public Function LoadWordList(ByVal FilePath As String) As String()
    Dim FileNum As Integer
    Dim TempArray() As String
    Dim WordCount As Long
    Dim MaxWords As Long
    Dim Line As String
    
    ' Initialize array with reasonable size
    MaxWords = 4180  ' TWL4 has around 4177 words
    ReDim TempArray(MaxWords - 1)
    WordCount = 0
    
    ' Get next free file number
    FileNum = FreeFile
    FilePath = App.Path + FilePath
    Debug.Print FilePath
    
    ' Open the file
    On Error GoTo ErrorHandler
    Open FilePath For Input As FileNum
    
    ' Read file line by line
    While Not EOF(FileNum)
        Line Input #FileNum, Line
        TempArray(WordCount) = Line
        WordCount = WordCount + 1
            
        ' Grow array if needed
        If WordCount >= MaxWords Then
            MaxWords = MaxWords + 50000
            ReDim Preserve TempArray(MaxWords - 1)
        End If
    Wend
    
    ' Resize array to actual number of words
    ReDim Preserve TempArray(WordCount - 1)
    LoadWordList = TempArray
    
CleanUp:
    Close #FileNum
    Exit Function
    
ErrorHandler:
    MsgBox "Error loading word list: " & Err.Description, vbCritical
    ReDim TempArray(0)
    LoadWordList = TempArray
    Resume CleanUp
End Function




