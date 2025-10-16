#!/bin/bash
# check_servers.sh - Check status of MCP servers
# This script checks if servers are running and shows their status

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BLUE}🔍 Langflow MCP Servers Status${NC}"
echo "=================================="

# Function to check server status
check_server() {
    local server_name="$1"
    local port="$2"
    local pid_file="$3"
    local server_script="$4"
    
    echo -n -e "${BLUE}📊 $server_name:${NC} "
    
    # Check if PID file exists and process is running
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p "$pid" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Running (PID: $pid)${NC}"
            
            # Check if port is listening
            if lsof -i ":$port" > /dev/null 2>&1; then
                echo -e "   🌐 Port $port: ${GREEN}✅ Listening${NC}"
            else
                echo -e "   🌐 Port $port: ${RED}❌ Not listening${NC}"
            fi
            
            # Show memory usage
            local memory=$(ps -o rss= -p "$pid" 2>/dev/null | awk '{print $1/1024 " MB"}' || echo "Unknown")
            echo -e "   💾 Memory: $memory"
            
        else
            echo -e "${RED}❌ Not running (stale PID file)${NC}"
            rm -f "$pid_file"
        fi
    else
        # Check if process is running without PID file
        if pgrep -f "$server_script" > /dev/null 2>&1; then
            local pid=$(pgrep -f "$server_script")
            echo -e "${YELLOW}⚠️  Running without PID file (PID: $pid)${NC}"
        else
            echo -e "${RED}❌ Not running${NC}"
        fi
    fi
}

# Check each server
check_server "Minimal MCP Server" "8002" "mcp_server_minimal.pid" "mcp_server_minimal.py"
check_server "MCP Proxy" "8003" "mcp_proxy.pid" "mcp_proxy.py"

echo ""
echo -e "${BLUE}🧪 Quick Tests:${NC}"

# Test minimal server
echo -n -e "Minimal server test: "
if curl -s -X POST http://localhost:8002/mcp/tools/list > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Responding${NC}"
else
    echo -e "${RED}❌ Not responding${NC}"
fi

# Test proxy server
echo -n -e "Proxy server test: "
if curl -s http://localhost:8003/tools > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Responding${NC}"
else
    echo -e "${RED}❌ Not responding${NC}"
fi

echo ""
echo -e "${BLUE}📋 Management Commands:${NC}"
echo "  • Start servers:  ./start_servers.sh"
echo "  • Stop servers:   ./stop_servers.sh"
echo "  • View logs:      tail -f *.log"
echo "  • Check this:     ./check_servers.sh"

# Show recent log entries if available
if [ -f "mcp_server_minimal.log" ] || [ -f "mcp_proxy.log" ]; then
    echo ""
    echo -e "${BLUE}📄 Recent Log Entries:${NC}"
    for log_file in *.log; do
        if [ -f "$log_file" ]; then
            echo -e "${YELLOW}--- $log_file (last 3 lines) ---${NC}"
            tail -n 3 "$log_file" 2>/dev/null || echo "No recent entries"
            echo ""
        fi
    done
fi
