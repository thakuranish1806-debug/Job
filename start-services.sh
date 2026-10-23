#!/bin/bash
# start-services.sh
# Starts backend and frontend in the background so they keep running even when Antigravity or terminal is closed.

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$PROJECT_DIR/logs"

echo "=========================================="
echo " Starting JobPortal Services in Background"
echo "=========================================="

# 1. Start Backend on Port 5000 if not already running
if lsof -i :5000 >/dev/null 2>&1; then
  echo "Backend is already running on http://localhost:5000 (Port 5000)"
else
  echo "Starting Node.js Backend..."
  (
    cd "$PROJECT_DIR/job-portal-backend" || exit 1
    nohup node server.js </dev/null > "$PROJECT_DIR/logs/backend.log" 2>&1 &
    BACKEND_PID=$!
    disown $BACKEND_PID 2>/dev/null || true
    echo $BACKEND_PID > "$PROJECT_DIR/logs/.backend.pid"
  )
  sleep 3
  if lsof -i :5000 >/dev/null 2>&1; then
    echo " Backend running on http://localhost:5000"
  else
    echo " Backend failed to start. Check logs/backend.log for details."
  fi
fi

# 2. Start Frontend on Port 5173 if not already running
if lsof -i :5173 >/dev/null 2>&1; then
  echo "Frontend is already running on http://localhost:5173 (Port 5173)"
else
  echo "Starting Vite Frontend..."
  CI=true nohup npx vite --host localhost --port 5173 </dev/null > "$PROJECT_DIR/logs/frontend.log" 2>&1 &
  FRONTEND_PID=$!
  disown $FRONTEND_PID 2>/dev/null || true
  echo $FRONTEND_PID > "$PROJECT_DIR/logs/.frontend.pid"
  sleep 2
  if lsof -i :5173 >/dev/null 2>&1; then
    echo " Frontend running on http://localhost:5173 (PID: $FRONTEND_PID)"
  else
    echo " Frontend failed to start. Check logs/frontend.log for details."
  fi
fi

echo "=========================================="
echo "Services are now running independently in the background!"
echo "Closing Antigravity IDE will NOT terminate these services."
echo "Frontend: http://localhost:5173"
echo "Backend:  http://localhost:5000"
echo "To stop services later, run: npm run stop:bg"
echo "=========================================="
