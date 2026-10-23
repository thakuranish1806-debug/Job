#!/bin/bash
# status-services.sh
# Checks status of backend and frontend services.

echo "=========================================="
echo " JobPortal Service Status"
echo "=========================================="

# Check Backend (5000)
if lsof -i :5000 >/dev/null 2>&1; then
  PID=$(lsof -ti :5000 | tr '\n' ' ')
  echo "Backend:  RUNNING on http://localhost:5000 (PID: $PID)"
else
  echo "Backend:  STOPPED (Port 5000 is free)"
fi

# Check Frontend (5173)
if lsof -i :5173 >/dev/null 2>&1; then
  PID=$(lsof -ti :5173 | tr '\n' ' ')
  echo "Frontend: RUNNING on http://localhost:5173 (PID: $PID)"
else
  echo "Frontend: STOPPED (Port 5173 is free)"
fi

echo "=========================================="
