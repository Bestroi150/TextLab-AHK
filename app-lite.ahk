#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
; VisibleNLP Lite
; Transparent text-processing / NLP teaching script
; No GUI version
;
; Hotkeys:
; Ctrl+Alt+V  = load clipboard as corpus
; Ctrl+Alt+O  = open TXT file as corpus
; Ctrl+Alt+C  = clean corpus
; Ctrl+Alt+F  = word frequency
; Ctrl+Alt+B  = bigram frequency
; Ctrl+Alt+T  = trigram frequency
; Ctrl+Alt+K  = KWIC concordance
; Ctrl+Alt+S  = corpus statistics
; Ctrl+Alt+H  = hapax legomena
; Ctrl+Alt+E  = export last result
; ============================================================

global Corpus := ""
global SourceName := ""
global LastResult := ""

^!v::LoadClipboard()
^!o::LoadFile()
^!c::CleanCorpus()
^!f::WordFrequency()
^!b::NgramFrequency(2, "BIGRAM FREQUENCY")
^!t::NgramFrequency(3, "TRIGRAM FREQUENCY")
^!k::KWIC()
^!s::CorpusStats()
^!h::HapaxWords()
^!e::ExportLastResult()

LoadClipboard() {
    global Corpus, SourceName

    if !A_Clipboard {
        MsgBox "Clipboard is empty."
        return
    }

    Corpus := A_Clipboard
    SourceName := "Clipboard"
    MsgBox "Clipboard loaded as corpus.`n`nCharacters: " StrLen(Corpus)
}

LoadFile() {
    global Corpus, SourceName

    path := FileSelect(1, , "Open corpus text file", "Text Files (*.txt)")
    if !path
        return

    try {
        Corpus := FileRead(path, "UTF-8")
    } catch {
        try {
            Corpus := FileRead(path)
        } catch Error as e {
            MsgBox "Could not read file.`n`n" e.Message
            return
        }
    }

    SourceName := path
    MsgBox "File loaded.`n`n" path "`n`nCharacters: " StrLen(Corpus)
}

RequireCorpus() {
    global Corpus

    if !Corpus {
        MsgBox "No corpus loaded.`n`nUse Ctrl+Alt+V for clipboard or Ctrl+Alt+O for a TXT file."
        return false
    }

    return true
}

CleanCorpus() {
    global Corpus, LastResult

    if !RequireCorpus()
        return

    text := Corpus

    text := StrLower(text)
    text := RegExReplace(text, "[“”]", '"')
    text := RegExReplace(text, "[‘’]", "'")
    text := RegExReplace(text, "[^\p{L}\p{N}'\s-]", " ")
    text := RegExReplace(text, "\R+", "`n")
    text := RegExReplace(text, "[ \t]+", " ")
    text := RegExReplace(text, " *`n *", "`n")
    text := Trim(text)

    Corpus := text
    LastResult := text
    A_Clipboard := text

    MsgBox "Corpus cleaned and copied to clipboard."
}

NormalizeForAnalysis(text) {
    text := StrLower(text)
    text := RegExReplace(text, "[“”]", '"')
    text := RegExReplace(text, "[‘’]", "'")
    text := RegExReplace(text, "[^\p{L}\p{N}'\s-]", " ")
    text := RegExReplace(text, "\s+", " ")
    return Trim(text)
}

WordFrequency() {
    global Corpus

    if !RequireCorpus()
        return

    text := NormalizeForAnalysis(Corpus)
    words := StrSplit(text, " ")
    counts := Map()

    for word in words {
        if word = ""
            continue

        counts[word] := counts.Has(word) ? counts[word] + 1 : 1
    }

    OutputCounts(counts, "WORD FREQUENCY")
}

NgramFrequency(n, title) {
    global Corpus

    if !RequireCorpus()
        return

    text := NormalizeForAnalysis(Corpus)
    words := StrSplit(text, " ")

    if words.Length < n {
        MsgBox "Corpus is too short for " n "-grams."
        return
    }

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

    OutputCounts(counts, title)
}

CorpusStats() {
    global Corpus, SourceName, LastResult

    if !RequireCorpus()
        return

    raw := Corpus
    text := NormalizeForAnalysis(raw)
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

    result := ""
    result .= "CORPUS STATISTICS`n"
    result .= "============================`n"
    result .= "Source: " SourceName "`n"
    result .= "Characters: " chars "`n"
    result .= "Tokens: " totalWords "`n"
    result .= "Unique words: " uniqueWords "`n"
    result .= "Lexical diversity: " lexicalDiversity "`n"

    LastResult := result
    A_Clipboard := result

    MsgBox result "`n`nCopied to clipboard."
}

HapaxWords() {
    global Corpus, LastResult

    if !RequireCorpus()
        return

    text := NormalizeForAnalysis(Corpus)
    words := StrSplit(text, " ")
    counts := Map()

    for word in words {
        if word = ""
            continue

        counts[word] := counts.Has(word) ? counts[word] + 1 : 1
    }

    result := "HAPAX LEGOMENA`n"
    result .= "Words appearing only once`n"
    result .= "============================`n"

    for word, count in counts {
        if count = 1
            result .= word "`n"
    }

    LastResult := result
    A_Clipboard := result

    MsgBox "Hapax list copied to clipboard."
}

KWIC() {
    global Corpus, LastResult

    if !RequireCorpus()
        return

    ib := InputBox("Enter search term:", "KWIC Concordance")
    if ib.Result != "OK"
        return

    term := Trim(ib.Value)

    if !term {
        MsgBox "No search term entered."
        return
    }

    windowBox := InputBox("Context window size:", "KWIC Concordance", , "6")
    if windowBox.Result != "OK"
        return

    window := Integer(windowBox.Value)
    if window < 1
        window := 6

    text := RegExReplace(Corpus, "\s+", " ")
    words := StrSplit(text, " ")

    result := ""
    matches := 0

    for i, word in words {
        cleanWord := StrLower(RegExReplace(word, "[^\p{L}\p{N}'-]", ""))

        if InStr(cleanWord, StrLower(term)) {
            matches++

            start := Max(1, i - window)
            stop := Min(words.Length, i + window)

            left := ""
            right := ""

            Loop i - start {
                left .= words[start + A_Index - 1] " "
            }

            Loop stop - i {
                right .= words[i + A_Index] " "
            }

            result .= PadLeft(Trim(left), 55)
            result .= "  >>> " word " <<<  "
            result .= Trim(right) "`n"
        }
    }

    if !result
        result := "No matches found."

    header := ""
    header .= "KWIC CONCORDANCE`n"
    header .= "============================`n"
    header .= "Search term: " term "`n"
    header .= "Matches: " matches "`n"
    header .= "Window: " window "`n`n"

    LastResult := header result
    A_Clipboard := LastResult

    MsgBox "KWIC complete.`nMatches: " matches "`n`nResults copied to clipboard."
}

OutputCounts(counts, title) {
    global LastResult

    items := []

    for key, val in counts {
        items.Push({key: key, val: val})
    }

    SortItemsByCount(items)

    topBox := InputBox("How many top results?", title, , "50")
    if topBox.Result != "OK"
        return

    topN := Integer(topBox.Value)
    if topN < 1
        topN := 50

    result := title "`n"
    result .= "============================`n"
    result .= "Count`tItem`n"
    result .= "----------------------------`n"

    limit := Min(topN, items.Length)

    Loop limit {
        item := items[A_Index]
        result .= item.val "`t" item.key "`n"
    }

    LastResult := result
    A_Clipboard := result

    MsgBox title " complete.`n`nResults copied to clipboard."
}

SortItemsByCount(items) {
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

ExportLastResult() {
    global LastResult

    if !LastResult {
        MsgBox "No result to export yet."
        return
    }

    path := FileSelect("S16", "visiblenlp_result.txt", "Save result", "Text Files (*.txt)")
    if !path
        return

    try {
        FileDelete(path)
    }

    try {
        FileAppend(LastResult, path, "UTF-8")
        MsgBox "Saved:`n" path
    } catch Error as e {
        MsgBox "Could not save file.`n`n" e.Message
    }
}

PadLeft(text, width) {
    while StrLen(text) < width
        text := " " text

    return text
}
