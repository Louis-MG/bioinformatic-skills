---
name: custom-skill-creator
description: Use when you need to create a new SKILL for the Vibe CLI. It standardizes the creation process with structured workflow and quality checks.
author: Louis-Maël Guéguen
version: 1.0
---

# Custom Skill Creator

## Overview
This SKILL automates and standardizes the creation of new SKILLs for the Vibe CLI. It enforces naming conventions, required structure, and content quality through a guided workflow.

**Example**: A well-structured SKILL has a valid YAML header, clear Overview, numbered Instructions, and passes all verification checks.

## Instructions

1. **Clarify SKILL Goal**
   1.1 Ask concrete questions:
      1.1.1 "What problem does this SKILL solve?"
      1.1.2 "What triggers this SKILL?"
      1.1.3 "What's the success criteria?"
   1.2 Narrow down the specific goal of the SKILL
   1.3 Define what the SKILL should enable Vibe to do
   1.4 Establish clear context of use
   1.5 Refine understanding until receiving explicit approval or "go on" confirmation

2. **Pre-creation Checklist**
   2.1 Verify skill name is unique and not already existing
   2.2 Confirm no naming conflicts with existing skills
   2.3 Ensure the directory path `~/.vibe/skills/` is accessible

3. **Create the SKILL File**
   3.1 **Directory Setup**
      3.1.1 Create a new directory under `~/.vibe/skills/` with your skill name (lowercase, hyphen-separated)
   3.2 **File Creation**
      3.2.1 Create a `SKILL.md` file inside that directory

4. **Write the YAML Header**
   4.1 **Fields**
      4.1.1 Add the frontmatter with these required fields:
      ```yaml
      ---
      name: [skill-name]
      description: Use when [brief usecase description]
      author: Louis-Maël Guéguen
      version: 1.0
      ---
      ```
   4.2 **Validation**
      4.2.1 The `name` must exactly match the directory name

5. **Add the Overview Section**
   5.1 Write a concise paragraph summarizing the SKILL's purpose and scope

6. **Write the Instructions**
   6.1 **Style**
      6.1.1 Use direct, imperative tone
      6.1.2 Keep sentences short and actionable
   6.2 **Structure**
      6.2.1 Organize into numbered steps
      6.2.2 Use sub-steps (nested numbering) when useful for clarity

7. **Include References or Scripts (If Applicable)**
   7.1 **Discovery**
      7.1.1 Ask: "Do you have existing scripts or reference materials to include?"
   7.2 **File Management**
      7.2.1 If yes, add them in a `/scripts` or `/resources` subdirectory
   7.3 **Validation**
      7.3.1 Verify script files have executable permissions if needed
      7.3.2 Check shebangs are present for executable scripts
   7.4 **Documentation**
      7.4.1 Reference them in the SKILL.md where appropriate

8. **Format Verification**
   8.1 **Header Check**
      8.1.1 Verify all required YAML fields are present and valid
      8.1.2 Flag any mismatch between `name` and directory name
      8.1.3 Identify missing required fields in the YAML header
   8.2 **Structure Check**
      8.2.1 Confirm sections follow SKILL conventions (header → overview → instructions → references)
      8.2.2 Note any missing required sections (Overview, Instructions)
      8.2.3 Report inconsistent formatting or structure
   8.3 **Language Check**
      8.3.1 Ensure tone is direct, sentences are concise, and instructions are unambiguous
      8.3.2 Highlight unclear or verbose descriptions

9. **SKILL evaluation**
   9.1 **Goal Alignment Check**
      9.1.1 Evaluate if the SKILL effectively addresses its stated purpose
      9.1.2 Check if it follows the single responsibility principle
      9.1.3 Verify the SKILL enables Vibe to perform the intended task
   9.2 **Quality Assessment**
      9.2.1 If improvements are possible, suggest specific changes
      9.2.2 If the SKILL meets its goal, confirm it is well-designed

10. **Final Review**
    10.1 Present the complete SKILL draft
    10.2 Ask: "Does this SKILL meet your requirements? Any sections to refine?"

11. **Deploy to Target Directory**
    11.1 If a target directory is specified, copy the entire skill folder and its contents
    11.2 Otherwise, skip deployment

## Constraints
- **Form**: Respects the format for the SKILL.md
- **Length**: Not more than 500 lines
- **Files**: All other referenced files must exist
- **Directory**: Name must be valid (lowercase, hyphen-separated)
- **Links**: All links and references must be accessible
- **Content Quality**: Must follow single responsibility principle (one clear purpose per SKILL)
