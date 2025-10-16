#!/bin/bash
# stop_servers.sh - Stop all MCP servers
# This script stops all running MCP servers and cleans up PID files

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

echo -e "${BLUE}🛑 Stopping Langflow MCP Servers${NC}"
echo "=================================="

# Function to stop a server
stop_server() {
    local server_name="$1"
    local pid_file="$2"
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p "$pid" > /dev/null 2>&1; then
            echo -e "${YELLOW}🔄 Stopping $server_name (PID: $pid)...${NC}"
            kill "$pid" 2>/dev/null || true
            
            # Wait for graceful shutdown
            local count=0
            while ps -p "$pid" > /dev/null 2>&1 && [ $count -lt 10 ]; do
                sleep 1
                count=$((count + 1))
            done
            
            # Force kill if still running
            if ps -p "$pid" > /dev/null 2>&1; then
                echo -e "${YELLOW}⚠️  Force stopping $server_name...${NC}"
                kill -9 "$pid" 2>/dev/null || true
            fi
            
            echo -e "${GREEN}✅ $server_name stopped${NC}"
        else
            echo -e "${YELLOW}⚠️  $server_name was not running${NC}"
        fi
        rm -f "$pid_file"
    else
        echo -e "${YELLOW}⚠️  No PID file found for $server_name${NC}"
    fi
}

# Stop all servers
echo -e "${BLUE}🔄 Stopping servers...${NC}"

# Stop Minimal MCP Server
stop_server "Minimal MCP Server" "mcp_server_minimal.pid"

# Stop MCP Proxy
stop_server "MCP Proxy" "mcp_proxy.pid"

# Also kill any remaining Python MCP server processes
echo -e "${YELLOW}🔍 Checking for remaining MCP server processes...${NC}"
pkill -f "mcp_server_minimal.py" 2>/dev/null || true
pkill -f "mcp_proxy.py" 2>/dev/null || true

# Clean up any remaining PID files (keep logs for debugging)
rm -f mcp_server_*.pid

echo ""
echo -e "${GREEN}🎉 All servers stopped successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Cleanup completed:${NC}"
echo "  • All server processes terminated"
echo "  • PID files removed"
echo "  • Log files preserved for debugging"
echo ""
echo -e "${YELLOW}💡 To start servers again, run: ./start_servers.sh${NC}"
