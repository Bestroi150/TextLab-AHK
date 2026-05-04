# TextLab-AHK

*A transparent AutoHotkey v2 text laboratory for digital humanities exploration and introductory NLP teaching*

---

## Overview

TextLab-AHK is a lightweight Windows desktop text-analysis environment written entirely in AutoHotkey v2.

It was developed with two parallel goals:

1. **to support exploratory digital humanities text work**, and
2. **to teach beginner Natural Language Processing concepts through highly readable code.**

Most NLP teaching tools today rely on Python ecosystems, external libraries, hidden tokenizers, and abstract package dependencies. TextLab-AHK takes the opposite approach: every core text-processing operation is visible, linear, and easy for students to inspect.

This makes the software not only a usable corpus experimentation tool, but also a practical instructional model for explaining:

* tokenization
* normalization
* lexical counting
* n-gram generation
* concordance construction
* corpus statistics
* vocabulary rarity

Because the codebase is plain AutoHotkey, students can open the scripts and directly follow what each algorithm is doing.

---

## Included Versions

The project contains two script editions.

---

### `app.ahk` — Full Desktop Version

This is the main interactive application containing:

* tabbed corpus workspace
* cleaning controls
* analysis modules
* KWIC concordance panel
* notes panel
* export system

It functions as a small desktop textual laboratory.

Recommended for:

* classroom demonstrations
* digital humanities workshops
* guided corpus experiments
* student labs

---

### `app-lite.ahk` — No-GUI Lightweight Version

This version removes the full graphical desktop interface and instead works through:

* keyboard hotkeys
* clipboard loading
* file loading
* popup prompts
* clipboard result output
* optional export

It is intentionally simpler and easier for students to inspect because the computational logic is not buried inside GUI layout code.

Recommended for:

* teaching source-code reading
* beginner NLP exercises
* algorithm walkthroughs
* minimalist corpus experiments

---

## Why AutoHotkey?

AutoHotkey was chosen deliberately.

While Python is more powerful in large-scale NLP, AutoHotkey offers several advantages for teaching introductory computational text analysis:

* extremely readable syntax
* straightforward loops
* simple string handling
* no external package installation
* instant desktop execution
* easy hotkey experimentation
* visible procedural logic

Students can therefore focus on **algorithmic understanding rather than environment configuration**.

The objective of TextLab-AHK is not industrial NLP production.

The objective is:

> to make text-processing algorithms understandable.

---

## Core NLP / DH Concepts Demonstrated

Each component of the software corresponds to a foundational text-processing concept.

| Module           | Demonstrates                  |
| ---------------- | ----------------------------- |
| Corpus Loading   | text ingestion                |
| Cleaning         | normalization / preprocessing |
| Word Frequency   | token counting                |
| Bigram / Trigram | n-gram construction           |
| Corpus Stats     | lexical measurement           |
| Hapax Legomena   | rare vocabulary behavior      |
| KWIC Concordance | context retrieval             |
| Notes / Export   | interpretive documentation    |

This allows instructors to move students through a full visible workflow:

raw text → cleaned corpus → token patterns → contextual reading → interpretation.

---

## Main Features

### Corpus Loading

Load corpus material from:

* `.txt` files
* OCR text
* copied archive excerpts
* clipboard text

Useful for small to medium classroom corpora.

---

### Cleaning / Normalization

Preprocessing options include:

* lowercase conversion
* punctuation removal
* number stripping
* whitespace normalization
* short-word removal
* regex substitutions

This helps demonstrate how preprocessing choices alter downstream linguistic results.

---

### Frequency Analysis

Generate:

* word frequency tables
* bigram frequencies
* trigram frequencies

Students can directly observe lexical repetition and phrase recurrence.

---

### Corpus Statistics

Quick descriptive metrics:

* character count
* token count
* unique vocabulary
* lexical diversity

Useful for introducing corpus descriptives.

---

### Hapax Legomena Detection

Lists all words appearing only once.

A simple but powerful introduction to vocabulary distribution.

---

### KWIC Concordance

Search a term and generate:

left context + keyword + right context.

This is one of the clearest demonstrations of why context matters beyond frequency counts.

---

### Notes and Export (`app.ahk`)

The full version includes:

* research note taking
* session documentation
* exportable reports

Useful for DH interpretive workflows.

---

## Hotkeys in `app-lite.ahk`

| Hotkey         | Function                 |
| -------------- | ------------------------ |
| Ctrl + Alt + V | Load clipboard as corpus |
| Ctrl + Alt + O | Open TXT file            |
| Ctrl + Alt + C | Clean corpus             |
| Ctrl + Alt + F | Word frequency           |
| Ctrl + Alt + B | Bigram frequency         |
| Ctrl + Alt + T | Trigram frequency        |
| Ctrl + Alt + K | KWIC concordance         |
| Ctrl + Alt + S | Corpus statistics        |
| Ctrl + Alt + H | Hapax words              |
| Ctrl + Alt + E | Export last result       |

---

## Suggested Educational Uses

TextLab-AHK is particularly effective for:

### Introductory NLP Courses

Demonstrating what happens inside basic text algorithms.

### Digital Humanities Labs

Running lightweight literary or historical corpus inspection.

### Corpus Linguistics Workshops

Exploring lexical recurrence and phrase distribution.

### OCR Cleanup Demonstrations

Showing normalization on messy archival text.

### Student Code Reading Exercises

Because the source code is short and linear, students can modify functions and immediately see textual consequences.

---

## Installation

### Requirements

* Windows
* AutoHotkey v2 installed

Download AutoHotkey:
[https://www.autohotkey.com/](https://www.autohotkey.com/)

---

### Setup

Place both scripts in the same project folder:

```text
app.ahk
app-lite.ahk
README.md
```

Then simply run either:

* `app.ahk` for the full GUI desktop laboratory
  or
* `app-lite.ahk` for the lightweight no-GUI teaching version

No external libraries are required.

---

## Recommended Teaching Workflow

A productive classroom sequence is:

### 1. Load a Raw Corpus

Show students an unprocessed text.

### 2. Apply Cleaning

Demonstrate normalization decisions.

### 3. Run Frequency Analysis

Discuss token repetition.

### 4. Generate N-grams

Show phrase windows and co-occurrence.

### 5. Run KWIC

Move from counting to contextual interpretation.

### 6. Open the Source Code

Walk through the AutoHotkey functions line by line.

This last stage is where TextLab-AHK becomes especially valuable: students can connect visible interface actions to visible procedural code.

---

## Conceptual Position

TextLab-AHK sits between:

* manual close reading,
* digital humanities experimentation,
* and introductory NLP pedagogy.

It is intentionally small, hackable, and transparent.

The software is best understood as:

> a visible computational text sandbox.

---

## License

Free for academic, classroom, personal, and experimental use.

Modification is encouraged.
