#!/bin/bash

sandbox(){
# Name of the tmux session
SESSION_NAME="sandbox"

# Start a new tmux session
tmux new-session -d -s $SESSION_NAME

# Split the window vertically
tmux split-window -h
tmux split-window -h
tmux split-window -v

# Run the first script in the left pane
tmux send-keys -t $SESSION_NAME:0.0 "ssh dev1" C-m
tmux send-keys -t $SESSION_NAME:0.0 "cd celeritas/backend" C-m
tmux send-keys -t $SESSION_NAME:0.0 "make start-auth-api" C-m
tmux send-keys -t $SESSION_NAME:0.0 "podman logs -f backend_auth-api_1" C-m

# Run the second script in the right pane
tmux send-keys -t $SESSION_NAME:0.1 "ssh dev1" C-m
tmux send-keys -t $SESSION_NAME:0.1 "cd celeritas/ui/web/apps/mobile-backend" C-m
tmux send-keys -t $SESSION_NAME:0.1 "bun run dev" C-m

tmux send-keys -t $SESSION_NAME:0.2 "ssh dev1" C-m

tmux send-keys -t $SESSION_NAME:0.3 "ssh dev1" C-m
tmux send-keys -t $SESSION_NAME:0.3 "docker exec -it postgres-local psql -U true_markets -d true_markets" C-m
# Attach to the tmux session
tmux attach-session -t $SESSION_NAME
}