#!/bin/bash

side() {
    # Prompt for the first command
    read -p "Enter the first command to run: " COMMAND1

    # Prompt for the second command
    read -p "Enter the second command to run: " COMMAND2

    # Define the session name
    local SESSION_NAME="commandsession"

    # Start a new tmux session
    tmux new-session -d -s $SESSION_NAME

    # Split the window into two panes
    tmux split-window -h  # Split horizontally (use -v for vertical)

    # Run the first command in the first pane
    tmux send-keys -t $SESSION_NAME:0.0 "$COMMAND1" C-m

    # Run the second command in the second pane
    tmux send-keys -t $SESSION_NAME:0.1 "$COMMAND2" C-m

    # Attach to the session
    tmux attach-session -t $SESSION_NAME
}