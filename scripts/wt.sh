#!/bin/bash

wt() {
    if [ $# -ne 1 ]; then
        echo "Usage: wt <branch-name>"
        echo "Creates or switches to a git worktree for the specified branch"
        return 1
    fi

    local BRANCH_NAME="$1"

    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local REPO_ROOT=$(git rev-parse --show-toplevel)
    local WORKTREE_PATH="$REPO_ROOT/../$BRANCH_NAME"

    if [ -d "$WORKTREE_PATH" ]; then
        echo "Worktree already exists at $WORKTREE_PATH"
        cd "$WORKTREE_PATH"
    else
        echo "Creating new worktree for branch '$BRANCH_NAME' at $WORKTREE_PATH"
        
        if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
            git worktree add "$WORKTREE_PATH" "$BRANCH_NAME"
        elif git show-ref --verify --quiet "refs/remotes/origin/$BRANCH_NAME"; then
            git worktree add "$WORKTREE_PATH" "origin/$BRANCH_NAME"
        else
            git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH"
        fi
        
        if [ $? -eq 0 ]; then
            cd "$WORKTREE_PATH"
            echo "Successfully created and switched to worktree: $WORKTREE_PATH"
        else
            echo "Failed to create worktree"
            return 1
        fi
    fi
}