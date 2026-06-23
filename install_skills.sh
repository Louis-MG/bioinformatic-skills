#!/bin/bash


# Skill Installation Script
# Installs skills to the correct folder for vibe CLI or claude CLI
# Usage: ./install_skills.sh -v --vibe --skill <path> --skill <path2>
#        ./install_skills.sh -c --claude --all
#        ./install_skills.sh -v --vibe --all

set -euo pipefail
# Default values
TARGET_CLI=""
SKILL_PATHS=()
VERBOSE=false
INSTALL_ALL=false
# Installation directories
VIBE_SKILLS_DIR="${HOME}/.vibe/skills"
CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

################################
#
# Display usage information
#
################################


usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] <skill_path>...
Install skills to the correct folder for vibe CLI or claude CLI.
Options:
  -v, --vibe         Install for vibe CLI (default: ${VIBE_SKILLS_DIR})
  -c, --claude       Install for claude CLI (default: ${CLAUDE_SKILLS_DIR})
  -h, --help         Show this help message
  -V, --verbose      Enable verbose output
  --skill <path>     Install a specific skill (can be used multiple times)
  --all              Install all skills in the current directory
Examples:
  $(basename "$0") -v --skill ~/my-skills/feature-dev
  $(basename "$0") -c --all
  $(basename "$0") -v --verbose --skill /path/to/skill1 --skill /path/to/skill2
  $(basename "$0") --claude --all --verbose
Note:
  Skills should be directory names containing a SKILL.md file.
  The script will create the target skills directory if it doesn't exist.
  Either --skill or --all must be specified.
EOF
}

################################
#
# Log messages with colors
#
################################

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}
log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}
log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}
log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

################################
#
# Check if a directory contains a valid skill
#
################################

is_valid_skill() {
    local skill_dir="$1"
    if [ ! -d "$skill_dir" ]; then
        return 1
    fi
    # Check for SKILL.md file (required for skills)
    if [ -f "${skill_dir}/SKILL.md" ]; then
        return 0
    fi
    # Optional: also check for skill.json or other indicators
    return 1
}

################################
#
# Get skill name from directory
#
################################

get_skill_name() {
    local skill_dir="$1"
    basename "$skill_dir"
}

################################
#
# Parse command line arguments
#
################################

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -v|--vibe)
                TARGET_CLI="vibe"
                shift
                ;;
            -c|--claude)
                TARGET_CLI="claude"
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -V|--verbose)
                VERBOSE=true
                shift
                ;;
            --all)
                INSTALL_ALL=true
                shift
                ;;
            --skill)
                # --skill requires an argument
                if [[ $# -lt 2 ]]; then
                    log_error "--skill requires a path argument"
                    usage
                    exit 1
                fi
                SKILL_PATHS+=("$2")
                shift 2
                ;;
            -*)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
            *)
                log_error "Unexpected argument: $1"
                log_error "Use --skill <path> to specify a skill, or --all to install all"
                usage
                exit 1
                ;;
        esac
    done
}

################################
#
# Validate that target CLI is specified
#
################################


validate_target() {
    if [ -z "$TARGET_CLI" ]; then
        log_error "Please specify a target CLI with -v/--vibe or -c/--claude"
        usage
        exit 1
    fi
    # Validate that either --all or --skill is specified
    if [ "$INSTALL_ALL" = false ] && [ ${#SKILL_PATHS[@]} -eq 0 ]; then
        log_error "Please specify either --all or --skill <path>"
        usage
        exit 1
    fi
}

################################
#
# Get target directory based on CLI
#
################################

get_target_dir() {
    case "$TARGET_CLI" in
        vibe)
            echo "$VIBE_SKILLS_DIR"
            ;;
        claude)
            echo "$CLAUDE_SKILLS_DIR"
            ;;
        *)
            log_error "Invalid CLI target: $TARGET_CLI"
            exit 1
            ;;
    esac
}

################################
#
# Create target directory if it doesn't exist
#
################################

create_target_dir() {
    local target_dir="$1"
    if [ ! -d "$target_dir" ]; then
        if $VERBOSE; then
            log_info "Creating target directory: $target_dir"
        fi
        mkdir -p "$target_dir"
        log_success "Created target directory: $target_dir"
    else
        if $VERBOSE; then
            log_info "Target directory already exists: $target_dir"
        fi
    fi
}

################################
#
# Install a single skill
#
################################

install_skill() {
    local skill_path="$1"
    local target_dir="$2"
    local skill_name
    local dest_path
    skill_name=$(get_skill_name "$skill_path")
    dest_path="${target_dir}/${skill_name}"
    # Check if skill is valid
    if ! is_valid_skill "$skill_path"; then
        log_warning "Skipping '$skill_path': Not a valid skill (missing SKILL.md)"
        return 1
    fi
    # Check if skill already exists at destination
    if [ -d "$dest_path" ]; then
        log_warning "Skill '$skill_name' already exists at $dest_path - skipping"
        return 0
    fi
    if "$VERBOSE"; then
        log_info "Installing skill: $skill_name"
        log_info "  From: $skill_path"
        log_info "  To:   $dest_path"
    fi
    # Copy the skill directory
    if cp -r "$skill_path" "$dest_path"; then
        log_success "Successfully installed skill: $skill_name"
        return 0
    else
        log_error "Failed to install skill: $skill_name"
        return 1
    fi
}

################################
#
#	Main function
#
################################

main() {
    if [ $# -eq 0 ]
    then
    	Help
    	exit 0
    fi
    # Parse arguments
    parse_args "$@"
    # Validate target CLI
    validate_target
    # Get target directory
    TARGET_DIR=$(get_target_dir)
    log_info "Target CLI: $TARGET_CLI"
    log_info "Target directory: $TARGET_DIR"
    # Create target directory
    create_target_dir "$TARGET_DIR"
    # If --all is specified, scan current directory for skills
    if [ "$INSTALL_ALL" = true ]; then
        log_info "Scanning current directory for all skills to install"
        # Find all directories with SKILL.md in current directory
        while IFS= read -r -d '' dir; do
            if [ -f "${dir}/SKILL.md" ]; then
                SKILL_PATHS+=("$dir")
            fi
        done < <(find . -maxdepth 2 -type d -print0 2>/dev/null)
        if [ ${#SKILL_PATHS[@]} -eq 0 ]; then
            log_error "No valid skills found in current directory"
            exit 1
        fi
        log_info "Found ${#SKILL_PATHS[@]} skill(s) to install"
    fi
    # Install each skill
    local success_count=0
    local failure_count=0
    local skip_count=0
    for skill_path in "${SKILL_PATHS[@]}"; do
        if install_skill "$skill_path" "$TARGET_DIR"; then
            ((success_count++))
        else
            ((failure_count++))
        fi
    done
    # Summary
    echo ""
    log_info "Installation Summary:"
    log_info "  Successfully installed: $success_count"
    if [ $failure_count -gt 0 ]; then
        log_warning "  Failed: $failure_count"
    fi
    if [ $skip_count -gt 0 ]; then
        log_info "  Skipped: $skip_count"
    fi
    if [ $failure_count -gt 0 ]; then
        exit 1
    fi
    log_success "All skills installed successfully!"
}

# Run main function with all arguments
main "$@"
