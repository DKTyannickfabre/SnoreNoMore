#!/usr/bin/env bash
set -e

TASK_ID=$1
WORKTREE_PATH=".agent/worktrees/wt-${TASK_ID}"

if [ -z "$TASK_ID" ]; then
  echo "Usage: ./cleanup_worktree.sh <task_id>"
  exit 1
fi

echo "[Orchestrator] Cleaning up worktree at ${WORKTREE_PATH}..."
git worktree remove --force "$WORKTREE_PATH"
git worktree prune