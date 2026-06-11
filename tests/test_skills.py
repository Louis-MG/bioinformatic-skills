#!/usr/bin/env python3
"""Unit tests for SKILL markdown files."""

import glob
import os
import re
import sys
from pathlib import Path

# Required YAML header fields
REQUIRED_FIELDS = {'name', 'description', 'author', 'version'}
MAX_LINES = 500
MAX_NAME_LENGTH = 64
MAX_DESCRIPTION_LENGTH = 1024
NAME_PATTERN = re.compile(r'^[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$')


def parse_yaml_header(file_path):
    """Parse YAML frontmatter from a markdown file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    if not lines or lines[0].strip() != '---':
        return None, "Missing YAML frontmatter start"
    
    # Find the end of the YAML header
    header_lines = []
    for i, line in enumerate(lines[1:], start=1):
        if line.strip() == '---':
            header_lines = lines[1:i]
            break
    else:
        return None, "Missing YAML frontmatter end"
    
    # Parse the header
    header = {}
    for line in header_lines:
        line = line.strip()
        if ':' in line:
            key, value = line.split(':', 1)
            header[key.strip()] = value.strip()
    
    return header, None


def validate_name(name, all_names):
    """Validate skill name against specifications."""
    errors = []
    
    # Check uniqueness
    if name in all_names:
        errors.append(f"Name '{name}' already exists")
    
    # Check length
    if len(name) > MAX_NAME_LENGTH:
        errors.append(f"Name '{name}' exceeds {MAX_NAME_LENGTH} characters")
    
    # Check pattern
    if not NAME_PATTERN.match(name):
        errors.append(
            f"Name '{name}' must be lowercase letters, numbers, and hyphens only, "
            "and must not start or end with a hyphen"
        )
    
    return errors


def validate_description(description):
    """Validate description against specifications."""
    errors = []
    
    # Check non-empty
    if not description or not description.strip():
        errors.append("Description must not be empty")
    
    # Check length
    if len(description) > MAX_DESCRIPTION_LENGTH:
        errors.append(f"Description exceeds {MAX_DESCRIPTION_LENGTH} characters")
    
    # Check content
    description_lower = description.lower()
    if 'use when' not in description_lower and 'what the skill does' not in description_lower:
        errors.append(
            "Description should describe what the skill does and when to use it "
            "(typically starts with 'Use when')"
        )
    
    return errors


def check_file(file_path, all_names):
    """Check a single SKILL.md file for compliance."""
    errors = []
    
    # Check line count
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    if len(lines) > MAX_LINES:
        errors.append(f"File has {len(lines)} lines (max {MAX_LINES})")
    
    # Check YAML header
    header, parse_error = parse_yaml_header(file_path)
    if parse_error:
        errors.append(f"Header parse error: {parse_error}")
    elif header is None:
        errors.append("No YAML header found")
    else:
        # Check required fields
        missing_fields = REQUIRED_FIELDS - set(header.keys())
        if missing_fields:
            errors.append(f"Missing required fields: {', '.join(sorted(missing_fields))}")
        
        # Check name matches directory name
        if 'name' in header:
            dir_name = os.path.basename(os.path.dirname(file_path))
            if header['name'] != dir_name:
                errors.append(
                    f"Name mismatch: header has '{header['name']}' "
                    f"but directory is '{dir_name}'"
                )
            
            # Validate name
            name_errors = validate_name(header['name'], all_names)
            errors.extend(name_errors)
        
        # Validate description
        if 'description' in header:
            desc_errors = validate_description(header['description'])
            errors.extend(desc_errors)
    
    return errors


def main():
    """Run all tests on SKILL.md files."""
    # Find all SKILL.md files
    skill_files = glob.glob('**/SKILL.md', recursive=True)
    
    if not skill_files:
        print("No SKILL.md files found!")
        return 1
    
    # Collect all existing skill names
    all_names = []
    for file_path in skill_files:
        header, _ = parse_yaml_header(file_path)
        if header and 'name' in header:
            all_names.append(header['name'])
    
    all_passed = True
    for file_path in sorted(skill_files):
        # Get names of other files for uniqueness check
        other_names = [n for n in all_names if n != os.path.basename(os.path.dirname(file_path))]
        errors = check_file(file_path, other_names)
        if errors:
            all_passed = False
            print(f"\n❌ {file_path}:")
            for error in errors:
                print(f"  - {error}")
        else:
            print(f"✓ {file_path}")
    
    if all_passed:
        print("\n✅ All tests passed!")
        return 0
    else:
        print(f"\n❌ {len([f for f in skill_files if check_file(f, [])])} test(s) failed!")
        return 1


if __name__ == '__main__':
    sys.exit(main())
