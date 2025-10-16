#!/bin/bash
# start_servers.sh - Start all MCP servers for Langflow tutorial
# This script ensures the virtual environment is activated and starts the appropriate servers

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BLUE}🚀 Starting Langflow MCP Servers${NC}"
echo "=================================="

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo -e "${RED}❌ Virtual environment not found!${NC}"
    echo "Please run the setup first:"
    echo "  python -m venv venv"
    echo "  source venv/bin/activate"
    echo "  pip install -r requirements.txt"
    exit 1
fi

# Activate virtual environment
echo -e "${YELLOW}📦 Activating virtual environment...${NC}"
source venv/bin/activate

# Check if required packages are installed
echo -e "${YELLOW}🔍 Checking dependencies...${NC}"
python -c "import torch, transformers, fastapi, uvicorn, PIL, requests" 2>/dev/null || {
    echo -e "${RED}❌ Missing dependencies!${NC}"
    echo "Installing required packages..."
    pip install torch transformers fastapi uvicorn pillow ultralytics opencv-python requests
}

# Function to start a server in background
start_server() {
    local server_name="$1"
    local server_script="$2"
    local port="$3"
    local pid_file="$4"
    
    echo -e "${YELLOW}🔄 Starting $server_name...${NC}"
    
    # Check if server is already running
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p "$pid" > /dev/null 2>&1; then
            echo -e "${YELLOW}⚠️  $server_name is already running (PID: $pid)${NC}"
            return 0
        else
            rm -f "$pid_file"
        fi
    fi
    
    # Start the server
    nohup python "$server_script" > "${server_script%.py}.log" 2>&1 &
    local pid=$!
    echo $pid > "$pid_file"
    
    # Wait a moment and check if it started successfully
    sleep 2
    if ps -p "$pid" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $server_name started successfully (PID: $pid)${NC}"
        echo -e "   📍 Port: $port"
        echo -e "   📄 Log: ${server_script%.py}.log"
    else
        echo -e "${RED}❌ Failed to start $server_name${NC}"
        echo -e "   Check ${server_script%.py}.log for details"
        rm -f "$pid_file"
        return 1
    fi
}

# Clean up old logs and PID files (before starting new servers)
echo -e "${YELLOW}🧹 Cleaning up old logs and PID files...${NC}"
rm -f mcp_server_*.log mcp_server_*.pid

# Function to kill processes on specific ports
kill_port() {
    local port="$1"
    local process_info=$(lsof -ti:$port 2>/dev/null)
    if [ ! -z "$process_info" ]; then
        echo -e "${YELLOW}🔪 Killing existing process on port $port (PID: $process_info)${NC}"
        kill -9 $process_info 2>/dev/null || true
        sleep 1
    fi
}

# Kill any existing processes on our ports
echo -e "${YELLOW}🔪 Checking for existing processes on ports 8002 and 8003...${NC}"
kill_port 8002
kill_port 8003

# Start servers
echo -e "${BLUE}🌐 Starting MCP Servers...${NC}"

# Start Minimal MCP Server (Port 8002)
start_server "Minimal MCP Server" "mcp_server_minimal.py" "8002" "mcp_server_minimal.pid"

# Start MCP Proxy (Port 8003)
start_server "MCP Proxy" "mcp_proxy.py" "8003" "mcp_proxy.pid"

echo ""
echo -e "${GREEN}🎉 All servers started successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Server Information:${NC}"
echo "  • Minimal MCP Server:  http://localhost:8002 (basic MCP tools)"
echo "  • MCP Proxy:           http://localhost:8003 (Langflow compatibility layer)"
echo ""
echo -e "${BLUE}🛠️  Management Commands:${NC}"
echo "  • Stop all servers:    ./stop_servers.sh"
echo "  • Check status:        ./check_servers.sh"
echo "  • View logs:           tail -f *.log"
echo ""
echo -e "${BLUE}🧪 Test Commands:${NC}"
echo "  • Test minimal server: curl -X POST http://localhost:8002/mcp/tools/list"
echo "  • Test proxy server:   curl http://localhost:8003/tools"
echo ""
echo -e "${YELLOW}💡 Tip: Keep this terminal open to see server logs${NC}"
echo -e "${YELLOW}   Press Ctrl+C to stop all servers${NC}"

# Wait for user interrupt
trap 'echo -e "\n${YELLOW}🛑 Stopping servers...${NC}"; ./stop_servers.sh; exit 0' INT

# Keep script running and show logs
echo -e "${BLUE}📊 Server logs (press Ctrl+C to stop):${NC}"
tail -f *.log
