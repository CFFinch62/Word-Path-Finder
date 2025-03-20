VERSION 5.00
Begin VB.Form frmMain 
   BackColor       =   &H00800000&
   Caption         =   "Word Path Finder Tester"
   ClientHeight    =   4680
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4725
   LinkTopic       =   "Form1"
   ScaleHeight     =   4680
   ScaleWidth      =   4725
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtSteps 
      BackColor       =   &H00C0FFC0&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1920
      TabIndex        =   9
      Top             =   2400
      Width           =   2295
   End
   Begin VB.TextBox txtPossible 
      BackColor       =   &H00C0FFC0&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1920
      TabIndex        =   8
      Top             =   1800
      Width           =   2295
   End
   Begin VB.CommandButton cmdReset 
      BackColor       =   &H000000FF&
      Caption         =   "Reset"
      Height          =   375
      Left            =   240
      Style           =   1  'Graphical
      TabIndex        =   7
      Top             =   4200
      Width           =   1455
   End
   Begin VB.CommandButton cmdFindPath 
      BackColor       =   &H0000C000&
      Caption         =   "Run Test"
      Height          =   375
      Left            =   1920
      Style           =   1  'Graphical
      TabIndex        =   6
      Top             =   4200
      Width           =   2295
   End
   Begin VB.TextBox txtPath 
      BackColor       =   &H00C0FFC0&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   975
      Left            =   1920
      MultiLine       =   -1  'True
      TabIndex        =   4
      Top             =   3000
      Width           =   2295
   End
   Begin VB.TextBox txtTargetWord 
      BackColor       =   &H00C0FFFF&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1920
      TabIndex        =   1
      Top             =   840
      Width           =   2295
   End
   Begin VB.TextBox txtStartWord 
      BackColor       =   &H00C0FFFF&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1920
      TabIndex        =   0
      Top             =   240
      Width           =   2295
   End
   Begin VB.Line Line 
      BorderColor     =   &H00FFFFFF&
      BorderWidth     =   3
      X1              =   120
      X2              =   4560
      Y1              =   1560
      Y2              =   1560
   End
   Begin VB.Label lblPathSteps 
      BackColor       =   &H00800000&
      Caption         =   "PATH STEPS:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   480
      TabIndex        =   11
      Top             =   2520
      Width           =   1335
   End
   Begin VB.Label Label1 
      BackColor       =   &H00800000&
      Caption         =   "PATH POSSIBLE:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   240
      TabIndex        =   10
      Top             =   1920
      Width           =   1575
   End
   Begin VB.Label lblWordPath 
      BackColor       =   &H00800000&
      Caption         =   "WORD PATH:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   480
      TabIndex        =   5
      Top             =   3360
      Width           =   1335
   End
   Begin VB.Label LBLtARGETwORD 
      BackColor       =   &H00800000&
      Caption         =   "TARGET WORD:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   960
      Width           =   1575
   End
   Begin VB.Label lblStartWord 
      BackColor       =   &H00800000&
      Caption         =   "START WORD:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   360
      TabIndex        =   2
      Top             =   360
      Width           =   1455
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub cmdFindPath_Click()

Dim Words() As String
Dim StartIdx, TargetIdx As Integer
Dim StartWord, TragetWord As String
Dim SearchResult As WordPathResult

cmdFindPath.Enabled = False

Words() = LoadWordList("\TWL4L.txt")

Randomize
StartIdx = Int((4177 * Rnd) + 1)
TargetIdx = Int((4177 * Rnd) + 1)

StartWord = Words(StartIdx)
txtStartWord.Text = StartWord

TargetWord = Words(TargetIdx)
txtTargetWord.Text = TargetWord

SearchResult = FindShortestWordPath(StartWord, TargetWord, Words)

txtPossible.Text = CStr(SearchResult.Possible)
txtSteps.Text = CStr(SearchResult.Steps)
For i = 0 To UBound(SearchResult.Path)
    txtPath.Text = txtPath.Text + SearchResult.Path(i) + " -> "
Next i

End Sub

Private Sub cmdReset_Click()

txtStartWord.Text = ""
txtTargetWord.Text = ""
txtPossible.Text = ""
txtSteps.Text = ""
txtPath.Text = ""
cmdFindPath.Enabled = True

End Sub
