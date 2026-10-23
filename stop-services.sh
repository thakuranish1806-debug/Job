#!/bin/bash
# stop-services.sh
# Stops backend and frontend background services.

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Stopping JobPortal background services..."

# Kill by PID if file exists
if [ -f "$PROJECT_DIR/logs/.backend.pid" ]; then
  BACKEND_PID=$(cat "$PROJECT_DIR/logs/.backend.pid")
  kill "$BACKEND_PID" >/dev/null 2>&1 || true
  rm -f "$PROJECT_DIR/logs/.backend.pid"
fi

if [ -f "$PROJECT_DIR/logs/.frontend.pid" ]; then
  FRONTEND_PID=$(cat "$PROJECT_DIR/logs/.frontend.pid")
  kill "$FRONTEND_PID" >/dev/null 2>&1 || true
  rm -f "$PROJECT_DIR/logs/.frontend.pid"
fi

# Also kill any remaining processes on port 5000 and 5173
PORT_5000_PIDS=$(lsof -ti :5000 2>/dev/null)
if [ -n "$PORT_5000_PIDS" ]; then
  kill -9 $PORT_5000_PIDS >/dev/null 2>&1 || true
  echo "Stopped backend on port 5000."
fi

PORT_5173_PIDS=$(lsof -ti :5173 2>/dev/null)
if [ -n "$PORT_5173_PIDS" ]; then
  kill -9 $PORT_5173_PIDS >/dev/null 2>&1 || true
  echo "Stopped frontend on port 5173."
fi

echo "All JobPortal services stopped."
