# DH Text Microscope

*A lightweight AutoHotkey v2 desktop laboratory for digital humanities text exploration and introductory NLP pedagogy*

---

## Overview

DH Text Microscope is a standalone Windows desktop application written in AutoHotkey v2 for exploratory text analysis in digital humanities workflows **and for teaching foundational Natural Language Processing concepts to students in a transparent, easy-to-follow way**.

Unlike industrial NLP libraries that hide operations behind large frameworks, this program exposes each textual transformation in visible, readable AutoHotkey code. Students can therefore observe exactly how raw text becomes analyzable linguistic data.

It is especially useful in:

* digital humanities seminars
* introductory NLP classes
* corpus linguistics workshops
* computational literary studies
* beginner text-mining instruction
* OCR cleanup demonstrations

The software acts as both:

* a practical text laboratory
  and
* a pedagogical demonstration model of basic NLP operations.

---

## Why This Tool Is Useful for Teaching NLP

Most beginner NLP students struggle because modern NLP environments often require:

* Python package management
* command line familiarity
* abstract libraries
* hidden prebuilt tokenizers
* opaque machine learning pipelines

DH Text Microscope avoids that complexity.

Because AutoHotkey code is linear and human-readable, students can directly inspect:

* how tokenization works
* how normalization changes text
* how punctuation removal affects counts
* how n-grams are built
* how lexical diversity is computed
* how concordance windows are generated

Every function can be opened and read almost like pseudocode.

This makes the application ideal for demonstrating:

> “what NLP is doing under the hood.”

Instead of merely pressing buttons, students can connect interface actions with visible algorithmic procedures.

---

## Pedagogical Design Philosophy

The application was intentionally designed around **transparent computational literacy**.

Each module corresponds to a classic introductory NLP concept:

| Interface Module | NLP Concept Taught               |
| ---------------- | -------------------------------- |
| Corpus Loading   | text ingestion                   |
| Cleaning Panel   | normalization / preprocessing    |
| Word Frequency   | token counting                   |
| Bigram / Trigram | n-gram generation                |
| Corpus Stats     | lexical measurement              |
| Hapax Legomena   | rarity / vocabulary distribution |
| KWIC             | concordance / context retrieval  |
| Notes            | interpretive annotation          |

This means the software can be used live in class while students watch:

raw text → cleaned text → tokens → patterns → contextual interpretation.

---

## Main Features

### 1. Corpus Management

Load textual material into the application from:

* plain `.txt` files
* copied OCR output
* clipboard text
* pasted archival material

Metadata can be attached manually for:

* author
* source
* year
* genre
* archive notes

This helps students understand that corpus analysis always begins with data acquisition and provenance.

---

### 2. Text Cleaning / Normalization

The cleaning panel allows preprocessing before analysis:

* lowercase normalization
* punctuation stripping
* number removal
* whitespace normalization
* removal of short words
* custom regex find/replace transformations

This is pedagogically useful because students can see how preprocessing decisions radically alter downstream statistics.

Excellent for demonstrating:

* noise reduction
* OCR cleanup
* token regularization
* corpus normalization

---

### 3. Quantitative Text Analysis

The Analyze tab currently includes:

#### Word Frequency

Counts recurring lexical items and introduces bag-of-words logic.

#### Bigram Frequency

Shows phrase recurrence and local co-occurrence.

#### Trigram Frequency

Demonstrates larger lexical chunking.

#### Corpus Statistics

Generates:

* character count
* token count
* unique word count
* lexical diversity estimate

Useful for explaining corpus descriptives.

#### Hapax Legomena

Lists words appearing only once in the corpus and introduces long-tail vocabulary behavior.

---

### 4. KWIC Concordance Engine

KWIC = **Key Word In Context**

Allows students to search for any term and instantly inspect:

* left context
* keyword
* right context

with adjustable window size.

Pedagogically this is one of the clearest ways to demonstrate:

* context-sensitive meaning
* collocational framing
* discourse repetition
* semantic nuance beyond raw frequency counts

Students quickly learn that counting words is not enough; context matters.

---

### 5. Humanities Research Notebook

An integrated Notes tab allows both instructor and students to maintain interpretive comments during computational exploration.

This reinforces a key DH/NLP lesson:

> computational output still requires human interpretation.

---

### 6. Export System

Export functions include:

* corpus export
* analysis export
* KWIC export
* notes export
* full session report export

Useful for assignments, lab reports, and classroom documentation.

---

## Included Global Hotkeys

| Hotkey         | Function              |
| -------------- | --------------------- |
| Ctrl + Alt + V | Load clipboard corpus |
| Ctrl + Alt + F | Run word frequency    |
| Ctrl + Alt + K | Run KWIC concordance  |
| Ctrl + Alt + S | Run corpus statistics |

---

## Suggested Classroom Use Cases

DH Text Microscope works especially well for:

### Introductory NLP Demonstrations

Students inspect visible code for tokenization, counting, and concordance.

### Corpus Linguistics Exercises

Run comparative frequency tests on speeches, novels, newspapers, or manifestos.

### OCR Cleaning Workshops

Demonstrate preprocessing with messy historical text.

### Literary Pattern Discovery

Search recurring ideological or symbolic vocabulary.

### Algorithm Transparency Lessons

Because all procedures are readable, students can modify the code and immediately observe consequences.

---

## Technical Requirements

* Windows OS
* AutoHotkey v2 installed

Download AutoHotkey:
[https://www.autohotkey.com/](https://www.autohotkey.com/)

---

## Installation

1. Install AutoHotkey v2.
2. Save the application script as:

```text id="zjlwmf"
app.ahk
```

3. Double-click to launch.

No external libraries required.

---

## Recommended Teaching Workflow

### Step 1 — Introduce Raw Corpus

Load a text and discuss textual noise.

### Step 2 — Demonstrate Cleaning

Apply preprocessing and show changed textual state.

### Step 3 — Run Frequency Analysis

Explain token counts and lexical repetition.

### Step 4 — Demonstrate N-grams

Show how phrases emerge from token windows.

### Step 5 — Run KWIC

Move from quantitative counting to contextual reading.

### Step 6 — Open the Source Code

Walk students through the AutoHotkey functions so they understand the algorithms directly.

This final step is where the tool becomes unusually effective pedagogically.

---

## Why AutoHotkey Instead of Python for Beginners?

Python is more powerful, but not always more transparent for first exposure.

AutoHotkey offers:

* minimal syntax
* visible GUI linkage
* straightforward loops
* easy string manipulation
* no package installation burden

Students can understand the mechanics faster because there is less infrastructural complexity.

The goal is not industrial NLP production.

The goal is:

> algorithmic comprehension.

---

## Conceptual Position

DH Text Microscope is intentionally positioned between:

* manual close reading
* beginner NLP pedagogy
* lightweight digital humanities experimentation

It is meant to function as a bridge between humanities interpretation and computational method.

---

## License

Free for personal, academic, classroom, and experimental use.

Modification encouraged.
