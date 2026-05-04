#Requires AutoHotkey v2.0
#SingleInstance Force

;Ctrl + Alt + V = load clipboard
;Ctrl + Alt + F = word frequency
;Ctrl + Alt + K = run KWIC (Keyword in Context)
;Ctrl + Alt + S = corpus stats



global App := {}
App.Text := ""
App.FilePath := ""
App.ResultWindows := []

Main()

Main() {
    global App

    App.Gui := Gui("+Resize", "DH Text Microscope")
    App.Gui.SetFont("s10", "Segoe UI")

    App.Tabs := App.Gui.AddTab3("x10 y10 w960 h620", [
        "Corpus",
        "Clean",
        "Analyze",
        "KWIC",
        "Notes",
        "Export"
    ])

    BuildCorpusTab()
    BuildCleanTab()
    BuildAnalyzeTab()
    BuildKWICTab()
    BuildNotesTab()
    BuildExportTab()

    App.Status := App.Gui.AddText("x10 y640 w960 h25", "Ready. Load text, paste from clipboard, or copy text and use Ctrl+Alt+V.")

    App.Gui.OnEvent("Size", MainResize)
    App.Gui.Show("w980 h680")
}

; ------------------------------------------------------------
; TAB 1: CORPUS
; ------------------------------------------------------------

BuildCorpusTab() {
    global App

    App.Tabs.UseTab("Corpus")

    App.LoadFileBtn := App.Gui.AddButton("x30 y55 w130 h32", "Load TXT File")
    App.LoadFileBtn.OnEvent("Click", LoadFile)

    App.PasteBtn := App.Gui.AddButton("x170 y55 w160 h32", "Paste Clipboard")
    App.PasteBtn.OnEvent("Click", PasteClipboard)

    App.ClearBtn := App.Gui.AddButton("x340 y55 w100 h32", "Clear")
    App.ClearBtn.OnEvent("Click", ClearCorpus)

    App.Meta := App.Gui.AddEdit("x460 y55 w480 h32", "Metadata: author / date / source / genre")

    App.TextBox := App.Gui.AddEdit("x30 y100 w910 h500 Multi WantTab -Wrap", "")
}

LoadFile(*) {
    global App

    path := FileSelect(1, , "Select a text file", "Text Documents (*.txt)")
    if !path
        return

    try {
        App.Text := FileRead(path, "UTF-8")
    } catch {
        try {
            App.Text := FileRead(path)
        } catch Error as e {
            MsgBox "Could not read file.`n`n" e.Message
            return
        }
    }

    App.FilePath := path
    App.TextBox.Value := App.Text
    SetStatus("Loaded: " path)
}

PasteClipboard(*) {
    global App

    if !A_Clipboard {
        MsgBox "Clipboard is empty."
        return
    }

    App.Text := A_Clipboard
    App.TextBox.Value := App.Text
    SetStatus("Clipboard text loaded.")
}

ClearCorpus(*) {
    global App

    App.Text := ""
    App.FilePath := ""
    App.TextBox.Value := ""
    SetStatus("Corpus cleared.")
}

; ------------------------------------------------------------
; TAB 2: CLEAN
; ------------------------------------------------------------

BuildCleanTab() {
    global App

    App.Tabs.UseTab("Clean")

    App.Lowercase := App.Gui.AddCheckbox("x30 y60 w250 h25", "Lowercase")
    App.RemovePunctuation := App.Gui.AddCheckbox("x30 y90 w250 h25", "Remove punctuation")
    App.RemoveNumbers := App.Gui.AddCheckbox("x30 y120 w250 h25", "Remove numbers")
    App.NormalizeSpaces := App.Gui.AddCheckbox("x30 y150 w250 h25 Checked", "Normalize whitespace")
    App.RemoveShortWords := App.Gui.AddCheckbox("x30 y180 w250 h25", "Remove words under 3 characters")

    App.Gui.AddText("x330 y60 w200 h25", "Custom Regex Find:")
    App.RegexFind := App.Gui.AddEdit("x330 y85 w300 h28", "")

    App.Gui.AddText("x330 y125 w200 h25", "Replace With:")
    App.RegexReplace := App.Gui.AddEdit("x330 y150 w300 h28", "")

    App.ApplyCleanBtn := App.Gui.AddButton("x30 y230 w160 h35", "Apply Cleaning")
    App.ApplyCleanBtn.OnEvent("Click", ApplyCleaning)

    App.CopyCleanBtn := App.Gui.AddButton("x200 y230 w180 h35", "Copy Cleaned Text")
    App.CopyCleanBtn.OnEvent("Click", CopyCleaned)

    App.CleanPreview := App.Gui.AddEdit("x30 y285 w910 h315 Multi ReadOnly -Wrap", "")
}

ApplyCleaning(*) {
    global App

    text := GetCurrentText()
    if !text
        return

    if App.Lowercase.Value
        text := StrLower(text)

    if App.RemovePunctuation.Value
        text := RegExReplace(text, "[^\p{L}\p{N}\s'-]", " ")

    if App.RemoveNumbers.Value
        text := RegExReplace(text, "\d+", " ")

    if App.RemoveShortWords.Value
        text := RemoveShortWords(text, 3)

    if App.NormalizeSpaces.Value {
        text := RegExReplace(text, "\R+", "`n")
        text := RegExReplace(text, "[ \t]+", " ")
        text := RegExReplace(text, " *`n *", "`n")
        text := Trim(text)
    }

    find := App.RegexFind.Value
    repl := App.RegexReplace.Value

    if find {
        try {
            text := RegExReplace(text, find, repl)
        } catch Error as e {
            MsgBox "Regex error:`n`n" e.Message
            return
        }
    }

    App.CleanPreview.Value := text
    SetStatus("Cleaning applied. Preview updated.")
}

CopyCleaned(*) {
    global App

    if !App.CleanPreview.Value {
        MsgBox "No cleaned text to copy."
        return
    }

    A_Clipboard := App.CleanPreview.Value
    SetStatus("Cleaned text copied to clipboard.")
}

RemoveShortWords(text, minLen) {
    output := ""
    words := StrSplit(RegExReplace(text, "\s+", " "), " ")

    for word in words {
        if StrLen(word) >= minLen
            output .= word " "
    }

    return Trim(output)
}

; ------------------------------------------------------------
; TAB 3: ANALYZE
; ------------------------------------------------------------

BuildAnalyzeTab() {
    global App

    App.Tabs.UseTab("Analyze")

    App.Gui.AddText("x30 y60 w160 h25", "Top results:")
    App.TopN := App.Gui.AddEdit("x120 y55 w60 h28", "50")

    App.WordFreqBtn := App.Gui.AddButton("x30 y100 w170 h35", "Word Frequency")
    App.WordFreqBtn.OnEvent("Click", WordFrequency)

    App.BigramBtn := App.Gui.AddButton("x210 y100 w170 h35", "Bigram Frequency")
    App.BigramBtn.OnEvent("Click", BigramFrequency)

    App.TrigramBtn := App.Gui.AddButton("x390 y100 w170 h35", "Trigram Frequency")
    App.TrigramBtn.OnEvent("Click", TrigramFrequency)

    App.StatsBtn := App.Gui.AddButton("x570 y100 w170 h35", "Corpus Stats")
    App.StatsBtn.OnEvent("Click", CorpusStats)

    App.HapaxBtn := App.Gui.AddButton("x750 y100 w170 h35", "Hapax Words")
    App.HapaxBtn.OnEvent("Click", HapaxWords)

    App.AnalysisOutput := App.Gui.AddEdit("x30 y155 w910 h445 Multi ReadOnly -Wrap", "")
}

WordFrequency(*) {
    text := NormalizeForAnalysis(GetCurrentText())
    if !text
        return

    words := StrSplit(text, " ")
    counts := Map()

    for word in words {
        if word = ""
            continue
        counts[word] := counts.Has(word) ? counts[word] + 1 : 1
    }

    ShowCounts(counts, "Word Frequency")
}

BigramFrequency(*) {
    NgramFrequency(2, "Bigram Frequency")
}

TrigramFrequency(*) {
    NgramFrequency(3, "Trigram Frequency")
}

NgramFrequency(n, title) {
    text := NormalizeForAnalysis(GetCurrentText())
    if !text
        return

    words := StrSplit(text, " ")
    counts := Map()

    maxStart := words.Length - n + 1

    Loop maxStart {
        startIndex := A_Index
        phrase := ""

        Loop n {
            phrase .= words[startIndex + A_Index - 1] " "
        }

        phrase := Trim(phrase)
        counts[phrase] := counts.Has(phrase) ? counts[phrase] + 1 : 1
    }

    ShowCounts(counts, title)
}

CorpusStats(*) {
    global App

    raw := GetCurrentText()
    text := NormalizeForAnalysis(raw)
    if !text
        return

    words := StrSplit(text, " ")
    counts := Map()

    for word in words {
        if word = ""
            continue
        counts[word] := counts.Has(word) ? counts[word] + 1 : 1
    }

    totalWords := words.Length
    uniqueWords := counts.Count
    chars := StrLen(raw)

    lexicalDiversity := totalWords ? Round(uniqueWords / totalWords, 4) : 0

    output := ""
    output .= "CORPUS STATS`n"
    output .= "-----------------------------`n"
    output .= "Characters: " chars "`n"
    output .= "Tokens: " totalWords "`n"
    output .= "Unique words: " uniqueWords "`n"
    output .= "Lexical diversity: " lexicalDiversity "`n"

    App.AnalysisOutput.Value := output
    SetStatus("Corpus stats generated.")
}

HapaxWords(*) {
    global App

    text := NormalizeForAnalysis(GetCurrentText())
    if !text
        return

    words := StrSplit(text, " ")
    counts := Map()

    for word in words {
        if word = ""
            continue
        counts[word] := counts.Has(word) ? counts[word] + 1 : 1
    }

    output := "HAPAX LEGOMENA - words appearing once`n"
    output .= "--------------------------------------`n"

    for word, count in counts {
        if count = 1
            output .= word "`n"
    }

    App.AnalysisOutput.Value := output
    SetStatus("Hapax list generated.")
}

; ------------------------------------------------------------
; TAB 4: KWIC
; ------------------------------------------------------------

BuildKWICTab() {
    global App

    App.Tabs.UseTab("KWIC")

    App.Gui.AddText("x30 y60 w100 h25", "Search term:")
    App.KWICTerm := App.Gui.AddEdit("x120 y55 w220 h28", "")

    App.Gui.AddText("x370 y60 w130 h25", "Window size:")
    App.KWICWindow := App.Gui.AddEdit("x470 y55 w60 h28", "6")

    App.KWICBtn := App.Gui.AddButton("x550 y53 w140 h32", "Run KWIC")
    App.KWICBtn.OnEvent("Click", RunKWIC)

    App.KWICCopyBtn := App.Gui.AddButton("x700 y53 w140 h32", "Copy Results")
    App.KWICCopyBtn.OnEvent("Click", CopyKWIC)

    App.KWICOutput := App.Gui.AddEdit("x30 y100 w910 h500 Multi ReadOnly -Wrap", "")
}

RunKWIC(*) {
    global App

    raw := GetCurrentText()
    term := Trim(App.KWICTerm.Value)

    if !raw {
        MsgBox "No corpus loaded."
        return
    }

    if !term {
        MsgBox "Enter a search term."
        return
    }

    window := Integer(App.KWICWindow.Value)
    if window < 1
        window := 6

    text := RegExReplace(raw, "\s+", " ")
    words := StrSplit(text, " ")

    results := ""
    matches := 0

    for i, word in words {
        cleanWord := StrLower(RegExReplace(word, "[^\p{L}\p{N}'-]", ""))

        if InStr(cleanWord, StrLower(term)) {
            matches++

            start := Max(1, i - window)
            stop := Min(words.Length, i + window)

            left := ""
            right := ""

            Loop i - start
                left .= words[start + A_Index - 1] " "

            Loop stop - i
                right .= words[i + A_Index] " "

            results .= PadLeft(Trim(left), 55) "  >>> " word " <<<  " Trim(right) "`n"
        }
    }

    if !results
        results := "No matches found."

    App.KWICOutput.Value := "KWIC for: " term "`nMatches: " matches "`n`n" results
    SetStatus("KWIC generated: " matches " matches.")
}

CopyKWIC(*) {
    global App

    if !App.KWICOutput.Value {
        MsgBox "No KWIC results to copy."
        return
    }

    A_Clipboard := App.KWICOutput.Value
    SetStatus("KWIC results copied.")
}

PadLeft(text, width) {
    while StrLen(text) < width
        text := " " text
    return text
}

; ------------------------------------------------------------
; TAB 5: NOTES
; ------------------------------------------------------------

BuildNotesTab() {
    global App

    App.Tabs.UseTab("Notes")

    App.Gui.AddText("x30 y60 w600 h25", "Research notes / observations:")
    App.Notes := App.Gui.AddEdit("x30 y90 w910 h470 Multi WantTab -Wrap", "")

    App.TimeStampBtn := App.Gui.AddButton("x30 y575 w150 h32", "Insert Timestamp")
    App.TimeStampBtn.OnEvent("Click", InsertTimestamp)
}

InsertTimestamp(*) {
    global App

    stamp := FormatTime(, "yyyy-MM-dd HH:mm")
    App.Notes.Value .= "`n`n[" stamp "]`n"
    SetStatus("Timestamp inserted.")
}

; ------------------------------------------------------------
; TAB 6: EXPORT
; ------------------------------------------------------------

BuildExportTab() {
    global App

    App.Tabs.UseTab("Export")

    App.ExportTextBtn := App.Gui.AddButton("x30 y60 w180 h35", "Export Corpus TXT")
    App.ExportTextBtn.OnEvent("Click", ExportCorpus)

    App.ExportAnalysisBtn := App.Gui.AddButton("x30 y110 w180 h35", "Export Analysis TXT")
    App.ExportAnalysisBtn.OnEvent("Click", ExportAnalysis)

    App.ExportKWICBtn := App.Gui.AddButton("x30 y160 w180 h35", "Export KWIC TXT")
    App.ExportKWICBtn.OnEvent("Click", ExportKWIC)

    App.ExportNotesBtn := App.Gui.AddButton("x30 y210 w180 h35", "Export Notes TXT")
    App.ExportNotesBtn.OnEvent("Click", ExportNotes)

    App.ExportAllBtn := App.Gui.AddButton("x30 y270 w180 h40", "Export Full Report")
    App.ExportAllBtn.OnEvent("Click", ExportFullReport)

    App.ExportInfo := App.Gui.AddEdit("x250 y60 w690 h500 Multi ReadOnly -Wrap",
        "Export tools save your corpus, analysis, concordance, and notes as plain text files.")
}

ExportCorpus(*) {
    global App
    SaveTextFile("corpus.txt", GetCurrentText())
}

ExportAnalysis(*) {
    global App
    SaveTextFile("analysis.txt", App.AnalysisOutput.Value)
}

ExportKWIC(*) {
    global App
    SaveTextFile("kwic.txt", App.KWICOutput.Value)
}

ExportNotes(*) {
    global App
    SaveTextFile("notes.txt", App.Notes.Value)
}

ExportFullReport(*) {
    global App

    report := ""
    report .= "DH TEXT MICROSCOPE REPORT`n"
    report .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm") "`n"
    report .= "Metadata: " App.Meta.Value "`n"
    report .= "Source file: " App.FilePath "`n"
    report .= "`n====================================`n"
    report .= "ANALYSIS`n"
    report .= "====================================`n"
    report .= App.AnalysisOutput.Value "`n"
    report .= "`n====================================`n"
    report .= "KWIC`n"
    report .= "====================================`n"
    report .= App.KWICOutput.Value "`n"
    report .= "`n====================================`n"
    report .= "NOTES`n"
    report .= "====================================`n"
    report .= App.Notes.Value "`n"

    SaveTextFile("dh_text_microscope_report.txt", report)
}

SaveTextFile(defaultName, text) {
    if !text {
        MsgBox "Nothing to export."
        return
    }

    path := FileSelect("S16", defaultName, "Save text file", "Text Documents (*.txt)")
    if !path
        return

    try {
        FileDelete(path)
    }

    try {
        FileAppend(text, path, "UTF-8")
        SetStatus("Saved: " path)
    } catch Error as e {
        MsgBox "Could not save file.`n`n" e.Message
    }
}

; ------------------------------------------------------------
; SHARED ANALYSIS HELPERS
; ------------------------------------------------------------

GetCurrentText() {
    global App

    text := App.TextBox.Value

    if !text {
        MsgBox "No text loaded. Load a file or paste clipboard text first."
        return ""
    }

    return text
}

NormalizeForAnalysis(text) {
    text := StrLower(text)
    text := RegExReplace(text, "[“”]", '"')
    text := RegExReplace(text, "[‘’]", "'")
    text := RegExReplace(text, "[^\p{L}\p{N}'\s-]", " ")
    text := RegExReplace(text, "\s+", " ")
    return Trim(text)
}

ShowCounts(counts, title) {
    global App

    topN := Integer(App.TopN.Value)
    if topN < 1
        topN := 50

    items := []

    for key, val in counts {
        items.Push({key: key, val: val})
    }

    SortItemsByCount(items)

    output := title "`n"
    output .= "--------------------------------------`n"
    output .= "Count`tItem`n"
    output .= "--------------------------------------`n"

    limit := Min(topN, items.Length)

    Loop limit {
        item := items[A_Index]
        output .= item.val "`t" item.key "`n"
    }

    App.AnalysisOutput.Value := output
    SetStatus(title " generated.")
}

SortItemsByCount(items) {
    ; Simple stable-ish insertion sort.
    ; Works fine for moderate DH experiments.
    Loop items.Length {
        i := A_Index
        current := items[i]
        j := i - 1

        while j >= 1 && items[j].val < current.val {
            items[j + 1] := items[j]
            j--
        }

        items[j + 1] := current
    }
}

SetStatus(msg) {
    global App
    App.Status.Value := msg
}

MainResize(thisGui, MinMax, Width, Height) {
    global App

    if MinMax = -1
        return

    try {
        App.Tabs.Move(10, 10, Width - 20, Height - 60)
        App.Status.Move(10, Height - 35, Width - 20, 25)

        App.TextBox.Move(30, 100, Width - 70, Height - 180)
        App.Meta.Move(460, 55, Width - 500, 32)

        App.CleanPreview.Move(30, 285, Width - 70, Height - 365)
        App.AnalysisOutput.Move(30, 155, Width - 70, Height - 235)
        App.KWICOutput.Move(30, 100, Width - 70, Height - 180)
        App.Notes.Move(30, 90, Width - 70, Height - 210)
        App.ExportInfo.Move(250, 60, Width - 290, Height - 180)
    }
}

; ------------------------------------------------------------
; GLOBAL HOTKEYS
; ------------------------------------------------------------

^!v:: {
    PasteClipboard()
}

^!f:: {
    WordFrequency()
}

^!k:: {
    RunKWIC()
}

^!s:: {
    CorpusStats()
}
