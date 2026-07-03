---
name: article-review
description: Use when you need to review and correct a scientific article, checking grammar, structure, flow, and subject-matter accuracy through specialized sub-agents.
author: Louis-Maël Guéguen
version: 1.2
---

# Article Correction

## Overview
This SKILL provides a comprehensive, multi-stage review process for scientific articles. It orchestrates three specialized sub-agents to systematically improve article quality: first through linguistic correction (grammar, vocabulary, phrasing), then through structural analysis (flow, paragraph chaining, figures/tables), and finally through subject-matter validation (introduction, discussion, conclusion). The skill is triggered when a user requests to review the writing of an article.
The results of each sub-agent work is summarised and written in a report in markdown format in the folder.

## Instructions

1. **Skill Activation**
   1.1 Trigger this SKILL when the user explicitly requests article review or correction
   1.2 Confirm the article text or file is available for analysis
   1.3 Extract or request the article abstract to determine subject matter specialty

2. **Phase 1: Linguistic Correction (english-teacher sub-agent)**
   2.1 Delegate grammar, conjugation, and syntax correction to the english-teacher sub-agent
   2.2 Ensure the sub-agent checks:
      2.2.1 Grammar accuracy
      2.2.2 Verb conjugation and tense consistency
      2.2.3 Phrasing clarity and naturalness
      2.2.4 Temporal agreement across the text
      2.2.5 Vocabulary appropriateness and precision
      2.2.6 Tone appropriateness for a scientific article: formal
   2.3 Collect and apply all linguistic corrections

3. **Phase 2: Structural Review (flow-reviewer sub-agent)**
   3.1 Delegate structural analysis to the flow-reviewer sub-agent
   3.2 Ensure the sub-agent verifies:
      3.2.1 Overall article structure and organization
      3.2.2 Logical chaining between paragraphs
      3.2.3 Flow of ideas and transitions
      3.2.4 Proper use (but not placement) of figures, tables, and equations
      3.2.5 Proper description of figures: title, axis description
      3.2.6 Consistency in section progression
      3.2.7 Correct placement of the text : no discussion in the results, no results in the discussion, no method in the discussion or results.
      3.2.8 Determine if parts of the text are enumerations of values: replace by a table
      3.2.9 Determine if parts of the text describe an equation: replace by the equation
   3.3 Collect and apply all structural recommendations

4. **Phase 3: Subject-Matter Review (specialist-reviewer sub-agent)**
   4.1 Determine the article's subject matter from the abstract or user input
   4.2 Delegate specialized content review to the specialist-reviewer sub-agent with the identified specialty
   4.3 Ensure the sub-agent validates:
      4.3.1 Introduction: context, research gap, objectives
      4.3.2 Discussion: interpretation of results, comparison with literature
      4.3.3 Conclusion: summary of findings, implications, limitations
   4.4 Collect and apply all subject-matter recommendations

5. **Result Compilation**
   5.1 Aggregate corrections from all three phases
   5.2 Present a consolidated report of all changes and recommendations
   5.3 Report where the corrections should be made using location in the pdf

6. **Quality Assurance**
   6.1 Verify all sub-agent outputs are coherent and non-conflicting
   6.2 Ensure the article maintains its original meaning and intent
   6.3 Confirm the final version is an improvement over the original

7. **Reporting results**
   7.1 Write a brief summary of the article to demonstrate your comprehension of it.
   7.2 Write a section for each sub-agent report
   7.2 Write for each section a table with 4 columns: the issue identified; the fix; the reason; a status checkbox. Write the checkbox as raw HTML (`<input type="checkbox">`), not markdown `- [ ]` syntax — GFM task-list syntax does not render inside table cells and produces disabled checkboxes even when it does.
   7.3 Write for each section a summary of the issues identified (if any) to help the writer understand what to change for the next article
   7.4 Write everything in a markdown file in the folder.

## Sub-Agents

This SKILL uses three specialized sub-agents:
- **english-teacher**: Handles linguistic and grammatical corrections
- **flow-reviewer**: Analyzes article structure and flow
- **specialist-reviewer**: Provides subject-matter expertise validation

Each sub-agent operates independently on the article and returns specific, actionable feedback within its domain of expertise.

## References
- Sub-agent configuration files: `english-teacher.toml`, `flow-reviewer.toml`, `specialist-reviewer.toml`
- Standard English
- Scientific writing best practices
- See the guidelines for specific journals in the Reference fodler.

## Constraints
- Maximum article length: 20,000 words per review session
- File formats supported: .md, .txt, .docx (converted to text), .pdf (text extracted)
- Response format: Structured markdown with clear section headers written as a file in the folder.
  Do not edit the pdf: the response must not be a re-wright of the article.
- All sub-agents must complete before final compilation
