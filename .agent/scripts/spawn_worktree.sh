#!/usr/bin/env bash
set -e

TASK_ID=$1
BRANCH_NAME="agent/task-${TASK_ID}"
WORKTREE_PATH=".agent/worktrees/wt-${TASK_ID}"

if [ -z "$TASK_ID" ]; then
  echo "Usage: ./spawn_worktree.sh <task_id>"
  exit 1
fi

echo "[Orchestrator] Spawning worktree at ${WORKTREE_PATH}..."
git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH" main
echo "[Orchestrator] Worktree ${TASK_ID} ready."
