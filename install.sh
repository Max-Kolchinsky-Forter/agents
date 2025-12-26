#!/bin/zsh
#
# Agentic Coding Framework - Install/Uninstall Script
#
# Installs:
# - Custom Agents (workflow modes with tool restrictions and handoffs)
# - Agent Skills (auto-activated specialized capabilities)
#
# For GitHub Copilot (coding agent, CLI, VSCode) and Claude Code
#
# Usage:
#   ./install.sh              # Install agents and skills
#   ./install.sh uninstall    # Uninstall
#

set -e

# Configuration
SCRIPT_DIR="${0:A:h}"

# Target directories
SKILLS_TARGET_DIR="$HOME/.github/skills"
CLAUDE_SKILLS_TARGET_DIR="$HOME/.claude/skills"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() { echo "${BLUE}ℹ${NC} $1"; }
success() { echo "${GREEN}✓${NC} $1"; }
warn() { echo "${YELLOW}⚠${NC} $1"; }
error() { echo "${RED}✗${NC} $1"; exit 1; }

# Show what will be linked
show_files() {
    echo "\n${BLUE}Agent Skills (auto-activated capabilities):${NC}"
    for d in "$SCRIPT_DIR"/.github/skills/*/; do
        [[ -d "$d" ]] && echo "    - $(basename "$d")/"
    done
    echo ""
}

# Install: Create symlinks for skills globally
install() {
    info "Installing Agentic Coding Framework..."
    info "Source: $SCRIPT_DIR/.github/"
    info "Target: ~/.github/"
    
    show_files
    
    local skill_count=0
    local skipped=0
    
    # Create global skills directory if it doesn't exist
    if [[ ! -d "$SKILLS_TARGET_DIR" ]]; then
        info "Creating global skills directory..."
        mkdir -p "$SKILLS_TARGET_DIR"
    fi
    
    # Link Agent Skills directories
    for src in "$SCRIPT_DIR"/.github/skills/*/; do
        [[ -d "$src" ]] || continue
        local name=$(basename "$src")
        local dest="$SKILLS_TARGET_DIR/$name"
        
        if [[ -L "$dest" ]]; then
            local current_target=$(readlink "$dest")
            if [[ "$current_target" == "${src%/}" ]]; then
                skipped=$((skipped + 1))
                continue
            else
                warn "Replacing existing symlink: $name"
                rm "$dest"
            fi
        elif [[ -e "$dest" ]]; then
            warn "Backing up existing skill: $name → $name.backup"
            mv "$dest" "$dest.backup"
        fi
        
        ln -s "${src%/}" "$dest"
        success "Linked skill: $name"
        skill_count=$((skill_count + 1))
    done
    
    # Create Claude Code compatibility symlink
    if [[ ! -L "$CLAUDE_SKILLS_TARGET_DIR" ]]; then
        info "Creating Claude Code compatibility symlink..."
        mkdir -p "$(dirname "$CLAUDE_SKILLS_TARGET_DIR")"
        if ln -s "$SKILLS_TARGET_DIR" "$CLAUDE_SKILLS_TARGET_DIR" 2>/dev/null; then
            success "Created: ~/.claude/skills → ~/.github/skills"
        fi
    elif [[ "$(readlink "$CLAUDE_SKILLS_TARGET_DIR")" == "$SKILLS_TARGET_DIR" ]]; then
        info "Claude Code symlink already exists"
    fi
    
    echo ""
    success "Installation complete!"
    info "Installed $skill_count skill symlinks ($skipped already existed)"
    echo ""
    echo "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo "${YELLOW}  Custom Agents (per-workspace linking required)${NC}"
    echo "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    info "VS Code only detects agents in workspace .github/agents/ folders."
    info "To use agents in a project, run from that project directory:"
    echo ""
    echo "    $SCRIPT_DIR/install.sh link"
    echo ""
    info "This creates symlinks to the agents without copying files."
    echo ""
    echo "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo "${YELLOW}  Agent Skills (auto-activate based on prompts)${NC}"
    echo "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    info "Skills auto-activate based on what you ask:"
    info "  • 'This test is failing' → debug"
    info "  • 'Teach me how this works' → mentor"
    info "  • 'Clean up dead code' → janitor"
    echo ""
    echo "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo "${YELLOW}  OPTIONAL: Enable Global Instructions${NC}"
    echo "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    info "To enable file-type coding standards globally, add to ~/.zshrc:"
    echo ""
    echo "    export COPILOT_CUSTOM_INSTRUCTIONS_DIRS=\"$SCRIPT_DIR/instructions\""
    echo ""
    info "Then restart your shell or run: source ~/.zshrc"
    echo ""
}

# Uninstall: Remove symlinks (skills only)
uninstall() {
    info "Uninstalling Agentic Coding Framework..."
    
    local skill_count=0
    
    # Remove Agent Skills symlinks
    info "Removing skills from $SKILLS_TARGET_DIR..."
    for src in "$SCRIPT_DIR"/.github/skills/*/; do
        [[ -d "$src" ]] || continue
        local name=$(basename "$src")
        local dest="$SKILLS_TARGET_DIR/$name"
        
        if [[ -L "$dest" ]]; then
            local current_target=$(readlink "$dest")
            if [[ "$current_target" == "${src%/}" ]]; then
                rm "$dest"
                success "Removed skill: $name"
                skill_count=$((skill_count + 1))
            fi
        fi
    done
    
    # Remove Claude Code compatibility symlink
    if [[ -L "$CLAUDE_SKILLS_TARGET_DIR" ]]; then
        local current_target=$(readlink "$CLAUDE_SKILLS_TARGET_DIR")
        if [[ "$current_target" == "$SKILLS_TARGET_DIR" ]]; then
            rm "$CLAUDE_SKILLS_TARGET_DIR"
            success "Removed: Claude Code compatibility symlink"
        fi
    fi
    
    echo ""
    success "Uninstallation complete!"
    info "Removed $skill_count skill symlinks"
    info "Note: Use 'unlink' to remove agents from individual workspaces"
}

# Link agents to current workspace
link_agents() {
    local workspace_agents_dir="$PWD/.github/agents"
    
    info "Linking agents to current workspace..."
    info "Source: $SCRIPT_DIR/.github/agents/"
    info "Target: $workspace_agents_dir"
    echo ""
    
    # Prevent linking into the source repo itself
    if [[ "$PWD" == "$SCRIPT_DIR" ]]; then
        error "Cannot link agents into the source repository itself"
    fi
    
    # Create .github/agents directory if needed
    mkdir -p "$workspace_agents_dir"
    
    local count=0
    for src in "$SCRIPT_DIR"/.github/agents/*.agent.md; do
        [[ -f "$src" ]] || continue
        local name=$(basename "$src")
        local dest="$workspace_agents_dir/$name"
        
        if [[ -L "$dest" ]]; then
            local current_target=$(readlink "$dest")
            if [[ "$current_target" == "$src" ]]; then
                info "Already linked: $name"
                continue
            else
                warn "Replacing existing symlink: $name"
                rm "$dest"
            fi
        elif [[ -e "$dest" ]]; then
            warn "Skipping (file exists): $name"
            continue
        fi
        
        ln -s "$src" "$dest"
        success "Linked: $name"
        count=$((count + 1))
    done
    
    echo ""
    success "Linked $count agents to $workspace_agents_dir"
    info "Agents are now available in this workspace's agent picker"
}

# Unlink agents from current workspace
unlink_agents() {
    local workspace_agents_dir="$PWD/.github/agents"
    
    info "Unlinking agents from current workspace..."
    
    if [[ ! -d "$workspace_agents_dir" ]]; then
        warn "No .github/agents directory found in current workspace"
        return
    fi
    
    local count=0
    for src in "$SCRIPT_DIR"/.github/agents/*.agent.md; do
        [[ -f "$src" ]] || continue
        local name=$(basename "$src")
        local dest="$workspace_agents_dir/$name"
        
        if [[ -L "$dest" ]]; then
            local current_target=$(readlink "$dest")
            if [[ "$current_target" == "$src" ]]; then
                rm "$dest"
                success "Unlinked: $name"
                count=$((count + 1))
            fi
        fi
    done
    
    # Remove empty .github/agents directory
    if [[ -d "$workspace_agents_dir" ]] && [[ -z "$(ls -A "$workspace_agents_dir")" ]]; then
        rmdir "$workspace_agents_dir"
        info "Removed empty .github/agents directory"
    fi
    
    echo ""
    success "Unlinked $count agents from current workspace"
}

# Main
case "${1:-install}" in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    link)
        link_agents
        ;;
    unlink)
        unlink_agents
        ;;
    *)
        echo "Usage: $0 [install|uninstall|link|unlink]"
        echo ""
        echo "Commands:"
        echo "  install    Install skills globally (~/.github/skills/)"
        echo "  uninstall  Remove global skill symlinks"
        echo "  link       Link agents to current workspace (.github/agents/)"
        echo "  unlink     Remove agent symlinks from current workspace"
        exit 1
        ;;
esac
