---
name: docx
description: "Use this skill whenever the user wants to create, read, edit, or manipulate Word documents (.docx files). Triggers include: any mention of 'Word doc', 'word document', '.docx', or requests to produce professional documents with formatting like tables of contents, headings, page numbers, or letterheads. Also use when extracting or reorganizing content from .docx files, inserting or replacing images in documents, performing find-and-replace in Word files, or working with tracked changes or comments."
license: Proprietary. LICENSE.txt has complete terms
type: tool-use
version: 1.0.0
---

# DOCX creation, editing, and analysis

## Overview

A .docx file is a ZIP archive containing XML files.

## Quick Reference

| Task | Approach |
|------|----------|
| Read/analyze content | `pandoc` or unpack for raw XML |
| Create new document | Use `docx-js` — see [references/creating-new.md](references/creating-new.md) |
| Edit existing document | Unpack → edit XML → repack — see Editing Existing Documents below |

### Converting .doc to .docx

```bash
python scripts/office/soffice.py --headless --convert-to docx document.doc
```

### Reading Content

```bash
# Text extraction with tracked changes
pandoc --track-changes=all document.docx -o output.md

# Raw XML access
python scripts/office/unpack.py document.docx unpacked/
```

### Converting to Images

```bash
python scripts/office/soffice.py --headless --convert-to pdf document.docx
pdftoppm -jpeg -r 150 document.pdf page
```

### Accepting Tracked Changes

```bash
python scripts/accept_changes.py input.docx output.docx
```

---

## Creating New Documents

Generate .docx files with JavaScript. Install: `npm install -g docx`

**Full patterns (page size, styles, lists, tables, images, hyperlinks, footnotes, TOC, headers/footers) — read [`references/creating-new.md`](references/creating-new.md).**

### Setup
```javascript
const { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, ImageRun,
        Header, Footer, AlignmentType, PageOrientation, LevelFormat, ExternalHyperlink,
        InternalHyperlink, Bookmark, FootnoteReferenceRun, PositionalTab,
        PositionalTabAlignment, PositionalTabRelativeTo, PositionalTabLeader,
        TabStopType, TabStopPosition, Column, SectionType,
        TableOfContents, HeadingLevel, BorderStyle, WidthType, ShadingType,
        VerticalAlign, PageNumber, PageBreak } = require('docx');

const doc = new Document({ sections: [{ children: [/* content */] }] });
Packer.toBuffer(doc).then(buffer => fs.writeFileSync("doc.docx", buffer));
```

### Validation
```bash
python scripts/office/validate.py doc.docx
```

### Key Rules (full list in references/creating-new.md)
- **Set page size explicitly** — docx-js defaults to A4; use US Letter (12240 × 15840 DXA)
- **Never use `\n`** — use separate Paragraph elements
- **Never use unicode bullets** — use `LevelFormat.BULLET` with numbering config
- **Tables need dual widths** — `columnWidths` array AND each cell `width`
- **Always use `WidthType.DXA`** — never `WidthType.PERCENTAGE` (breaks in Google Docs)
- **Use `ShadingType.CLEAR`** — never SOLID for table shading

---

## Editing Existing Documents

**Follow all 3 steps in order.**

### Step 1: Unpack
```bash
python scripts/office/unpack.py document.docx unpacked/
```

### Step 2: Edit XML

Edit files in `unpacked/word/`. See [`references/xml-reference.md`](references/xml-reference.md) for XML patterns (tracked changes, comments, images).

**Use "Claude" as the author** for tracked changes and comments, unless explicitly requested otherwise.

**Use the Edit tool directly for string replacement. Do not write Python scripts.**

**CRITICAL: Use smart quotes for new content:**
```xml
<w:t>Here&#x2019;s a quote: &#x201C;Hello&#x201D;</w:t>
```

| Entity | Character |
|--------|-----------|
| `&#x2018;` | ' (left single) |
| `&#x2019;` | ' (right single / apostrophe) |
| `&#x201C;` | " (left double) |
| `&#x201D;` | " (right double) |

**Adding comments:**
```bash
python scripts/comment.py unpacked/ 0 "Comment text with &amp; and &#x2019;"
python scripts/comment.py unpacked/ 1 "Reply text" --parent 0
```

### Step 3: Pack
```bash
python scripts/office/pack.py unpacked/ output.docx --original document.docx
```

### Common Pitfalls
- **Replace entire `<w:r>` elements**: When adding tracked changes, replace the whole `<w:r>...</w:r>` block
- **Preserve `<w:rPr>` formatting**: Copy the original run's `<w:rPr>` into tracked change runs

---

## Dependencies

- **pandoc**: Text extraction
- **docx**: `npm install -g docx` (new documents)
- **LibreOffice**: PDF conversion (via `scripts/office/soffice.py`)
- **Poppler**: `pdftoppm` for images

---

## Anti-Triggers

- PDF, spreadsheet (.xlsx), or PowerPoint (.pptx) files — use pdf/xlsx/pptx skills
- Google Docs (not .docx) — no local file manipulation needed
- General coding tasks with no Word document output
