#!/usr/bin/env python3
"""
MCP Proxy for Langflow - Wraps MCP server in Langflow-compatible format
Based on the solution provided by the user
"""

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
import requests
import json
import uvicorn

app = FastAPI(title="MCP Proxy for Langflow")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# MCP server endpoints - using image AI server for real AI functionality
MCP_BASE_URL = "http://localhost:8004"  # Different port for image AI server
MCP_TOOLS_URL = f"{MCP_BASE_URL}/mcp/tools/list"
MCP_CALL_URL = f"{MCP_BASE_URL}/mcp/tools/call"
MCP_RESOURCES_LIST_URL = f"{MCP_BASE_URL}/mcp/resources/list"
MCP_RESOURCES_READ_URL = f"{MCP_BASE_URL}/mcp/resources/read"

@app.get("/")
async def root():
    return {"message": "MCP Proxy for Langflow", "status": "running"}

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.get("/tools")
async def get_tools():
    """
    Langflow calls this to get available tools
    Returns a single JSON response with all tools
    """
    try:
        response = requests.post(MCP_TOOLS_URL, timeout=5)
        response.raise_for_status()
        data = response.json()
        
        # Extract tools from MCP response
        tools = data.get("result", {}).get("tools", [])
        
        # Return in Langflow-compatible format
        return {
            "tools": tools,
            "count": len(tools),
            "status": "success"
        }
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"MCP server error: {str(e)}")

@app.post("/call")
async def call_tool(tool_name: str, args: dict = None):
    """
    Langflow calls this to execute a tool
    """
    try:
        # Image AI server expects MCP JSON-RPC format
        payload = {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "tools/call",
            "params": {
                "toolName": tool_name,
                "args": args or {}
            }
        }
        
        response = requests.post(MCP_CALL_URL, json=payload, timeout=30)
        response.raise_for_status()
        data = response.json()
        
        # Return the result in Langflow-compatible format
        return {
            "result": data.get("result", {}),
            "status": "success"
        }
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Tool call failed: {str(e)}")

@app.get("/echo")
async def echo_text(text: str = Query(..., description="Text to echo")):
    """
    Direct echo tool for testing
    """
    return {
        "result": {
            "content": [{
                "type": "text",
                "text": f"✅ Echo from MCP Proxy: {text}"
            }]
        },
        "status": "success"
    }

@app.get("/resources")
async def get_resources():
    """
    Get list of available resources from MCP server
    """
    try:
        response = requests.post(MCP_RESOURCES_LIST_URL, timeout=5)
        response.raise_for_status()
        data = response.json()
        
        # Extract resources from MCP response
        resources = data.get("result", {}).get("resources", [])
        
        return {
            "resources": resources,
            "count": len(resources),
            "status": "success"
        }
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"MCP server error: {str(e)}")

@app.post("/resources/read")
async def read_resource(uri: str):
    """
    Read a specific resource by URI
    """
    try:
        payload = {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "resources/read",
            "params": {
                "uri": uri
            }
        }
        
        response = requests.post(MCP_RESOURCES_READ_URL, json=payload, timeout=10)
        response.raise_for_status()
        data = response.json()
        
        return {
            "result": data.get("result", {}),
            "status": "success"
        }
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Resource read failed: {str(e)}")

if __name__ == "__main__":
    print("🚀 Starting MCP Proxy for Langflow on http://localhost:8003")
    uvicorn.run(app, host="0.0.0.0", port=8003)
