---
name: generate-graphical-abstract
description: Use when the user wants to generate a graphical abstract (PNG image) for a scientific publication. The Skill makes vibe analyzing the manuscript's introduction/abstract, proposing a visual layout, iterating with the user, and rendering the final image.
aliases: [/graphical-abstract, /ga]
author: Louis-MAël Guéguen
version: 1.0
---

# Overview :

Generate Graphical Abstract
Purpose: Create a publication-ready graphical abstract (PNG) for a scientific manuscript by extracting key insights, proposing a visual design, and iterating with the user until approval.
Constraints:
Output must be a PNG image (not SVG).
Must work with manuscripts in /workspace or a user-specified path.
User must explicitly approve the final layout, model, and palette before generation.
Always generate 3 image variations for user selection before finalizing.
Must be simple enough to not look like a poster.


## PHASE 1 — DISCOVERY

Goal: Locate and validate the manuscript files.

### 1.1 Identify Target Files

Action: List all files in the current directory and /workspace.
Prompt:
To generate a graphical abstract, I need your manuscript. Available files:
{file_list}
Which file contains the introduction and abstract? (Provide path or "cancel")


Validation:

If user provides a path, check if it exists and is readable.
If no files are found, ask: "No manuscript files detected. Upload your manuscript (PDF/TEX/DOCX/TXT) and retry."
If user says "cancel", abort.

### 1.2 Extract Introduction & Abstract

Action: Parse the file to isolate the Introduction and Abstract sections.
PDF: Use pdfplumber or PyPDF2 to extract text.
TEX/LaTeX: Search for \begin{abstract} and \section{Introduction}.
DOCX: Use python-docx to extract by heading.
TXT/MD: Split by ## Abstract or ## Introduction headers.
Fallback: If sections are unlabeled, extract the first 1000 words and ask:
Could not auto-detect sections. Is this the abstract and introduction?

--- [extract] ---

Reply "yes", "no", or edit the text below:

PHASE 2 — CONTENT ANALYSIS

Goal: Extract the goal, context, and method from the text.

## 2.1 Summarize Context

Action: Use an LLM to condense the introduction into 3 bullet points:
Background/field
Key challenge/gap
Motivation
Output Template:

**Context**:

- Field: [1 sentence]

- Gap: [1 sentence]

- Motivation: [1 sentence]


## 2.2 Identify Goal

Action: Extract the primary objective from the abstract.
Prompt to LLM:
What is the single primary goal of this study? Respond in one sentence, starting with "To [verb]...".

Text: [abstract]

Validation: Ask user:
Is the goal correctly identified?

> {goal}

Reply "yes", "no", or provide a correction.

## 2.3 Summarize Method

Action: Extract the methodology into 3-5 key steps.
Output Template:

**Method**:

1. [Step 1]

2. [Step 2]

3. [Step 3]


# PHASE 3 — LAYOUT PROPOSAL

Goal: Propose a visual layout for the graphical abstract.

## 3.1 Generate Layout Options

Action: Use the context, goal, and method to propose 3 layout templates:
Classic: Title + Goal (top), Method (center flow diagram), Key Result (bottom highlight).
Problem-Solution: Left (Problem/Context), Right (Solution/Method), Arrow connecting.
Minimalist: Goal (large text), Method (icons + labels), Result (small text).
Visual Description: For each, provide:
A 5-line ASCII mockup.
Icon suggestions (e.g., 🔬 for experiments, 📊 for data analysis).

## 3.2 User Selection & Customization

Prompt:
Proposed layouts:

--- [Option 1: Classic] ---

{ascii_1}

Icons: {icons_1}

--- [Option 2: Problem-Solution] ---

{ascii_2}

Icons: {icons_2}

--- [Option 3: Minimalist] ---

{ascii_3}

Icons: {icons_3}

Select a layout (1/2/3), request a hybrid, or describe a custom design.

Iteration: Repeat until user approves a layout with:
Reply "approve" to confirm, or describe changes.


# PHASE 4 — COLOR PALETTE SELECTION

Goal: Select a color palette matching the target journal or user preference.

## 5.1 Propose Journal Palettes

Prompt:
Select a color palette (or "custom" to define your own):

--- [1] Nature Communications ---

Primary: #239eb5 (Teal) | Secondary: #f16521 (Orange) | Accent: #4eb34b (Green) | Neutral: #2b2b2b (Dark Gray)

Preview: [Teal/Orange/Green block]

--- [2] ISME Journal (ISMEJ) ---

Primary: #1f77b4 (Blue) | Secondary: #ff7f0e (Orange) | Accent: #2ca02c (Green) | Neutral: #7f7f7f (Gray)

Preview: [Blue/Orange/Green block]

--- [3] Oxford Group (Oxford University Press) ---

Primary: #002147 (Oxford Blue) | Secondary: #ffc72c (Oxford Gold) | Accent: #c41e3d (Red) | Neutral: #ffffff (White)

Preview: [Blue/Gold/Red block]

--- [4] BMC Group (Biomed Central) ---

Primary: #006699 (BMC Blue) | Secondary: #009933 (BMC Green) | Accent: #ff6600 (Orange) | Neutral: #333333 (Dark Gray)

Preview: [Blue/Green/Orange block]

--- [5] Custom ---

Define your own palette (provide 2-4 hex colors).

Your choice (1-5):

Validation:
For "custom", prompt:
Enter 2-4 hex colors (comma-separated, e.g., "#123456, #abcdef"):
Confirm selection:
Selected palette: {palette_name} ({colors}). Confirm? (yes/no)


# PHASE 5 — IMAGE GENERATION

Goal: Render 3 variations of the approved layout as PNGs for user selection.

## 5.1 Build Prompts for Variations

Action: Construct 3 distinct prompts from the approved layout:
Default: Exact layout as approved.
Emphasis on Goal: Increase goal text size/weight, simplify method visualization.
Emphasis on Method: Expand method flowchart, reduce other elements.
Common Parameters:
Style: Scientific, clean, vector-style.
Colors: User-selected palette (explicitly mentioned).
Aspect Ratio: 16:9 (default) or user-specified.
Resolution: Minimum 1920x1080.

## 5.2 Generate 3 Variations

Action:
If 1 model selected: Generate all 3 variations with that model (vary seed or prompt slightly).
If >1 model selected: Distribute variations across models (e.g., 2 from first model, 1 from second).
Fallback: If a model fails, retry with another or default to sdxl.

## 5.3 Present for Selection

Prompt:
Generated 3 variations for your graphical abstract:

--- [1] Default Layout ---

{image_path_1} (via {model_1})

[Thumbnail preview]

--- [2] Goal-Emphasized ---

{image_path_2} (via {model_2})

[Thumbnail preview]

--- [3] Method-Emphasized ---

{image_path_3} (via {model_3})

[Thumbnail preview]

Select one to finalize (1-3), or "retry" to regenerate all.


# PHASE 6 — FINALIZE & SAVE

Goal: Save the approved image and metadata.

## 6.1 Confirm Selection

Prompt:
You selected variation {n}. Finalize? (yes/no)
If "no": Return to Phase 6.2 (regenerate 3 new variations).

## 6.2 Save Outputs

Action: Save the selected image as:
manuscript_name}_graphical_abstract.png
manuscript_name}_graphical_abstract_variation_{n}.png (backup)
Prompt: {manuscript_name}_ga_prompt.txt
Metadata: {manuscript_name}_ga_metadata.json (includes model, palette, layout, timestamp).


# PHASE 7 — CLEANUP

Action: Remove temporary files (extracted text, intermediate images).
Output:
Graphical abstract finalized and saved to:

- Image: {image_path}

- Prompt: {prompt_path}

- Metadata: {metadata_path}

ERROR HANDLING

| Scenario | Action |

|----------|--------|

| No manuscript found | Prompt user to upload files. |

| Cannot parse sections | Show raw text, ask user to paste abstract/introduction. |

| Invalid color hex | Prompt for correction. |

| Image generation fails for a variation | Replace with a fallback (simplified prompt) or retry. |

| All variations rejected | Return to Phase 3 (Layout) or Phase 5 (Palette).



EXAMPLE WORKFLOW


User: /generate-graphical-abstract

Vibe: [Lists files] Which file contains the introduction and abstract?

User: paper.pdf

Vibe: [Extracts text] Is this the abstract and introduction? > yes

Vibe:

  **Context**: [Climate modeling, polar data gap, improve predictions]

  **Goal**: To develop a machine learning model for high-resolution polar climate simulation.

  **Method**: [1. Dataset 2. Training 3. Validation]

Vibe: [Proposes 3 layouts]

User: 2

Vibe: Approve layout? > approve

Vibe: Select palette: 1. Nature, 2. ISMEJ, 3. Oxford, 4. BMC > 3

Vibe: [Generates 3 variations via DALL·E 3]

Vibe: Select one to finalize (1-3) > 2

Vibe: Finalize variation 2? > yes

Vibe: Saved to paper_graphical_abstract.png
