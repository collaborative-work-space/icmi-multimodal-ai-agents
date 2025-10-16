#!/usr/bin/env python3
"""
Minimal HTTP MCP Server for Langflow Desktop
No external dependencies - just FastAPI
"""

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
import json
import uvicorn

app = FastAPI(title="Minimal MCP Server")

# Define tools
TOOLS = [
    {
        "name": "echo_text",
        "description": "Echo back the input text",
        "inputSchema": {
            "type": "object",
            "properties": {
                "text": {
                    "type": "string",
                    "description": "Text to echo back"
                }
            },
            "required": ["text"]
        }
    },
    {
        "name": "add_numbers",
        "description": "Add two numbers",
        "inputSchema": {
            "type": "object",
            "properties": {
                "a": {"type": "number"},
                "b": {"type": "number"}
            },
            "required": ["a", "b"]
        }
    },
    {
        "name": "describe_image",
        "description": "Describe an image from base64 data",
        "inputSchema": {
            "type": "object",
            "properties": {
                "image_data": {
                    "type": "string",
                    "description": "Base64 encoded image data"
                }
            },
            "required": ["image_data"]
        }
    },
    {
        "name": "find_item_in_image",
        "description": "Find a specific item in an image",
        "inputSchema": {
            "type": "object",
            "properties": {
                "image_data": {
                    "type": "string",
                    "description": "Base64 encoded image data"
                },
                "search_text": {
                    "type": "string",
                    "description": "Text to search for in the image"
                }
            },
            "required": ["image_data", "search_text"]
        }
    }
]

@app.get("/")
async def root():
    return {"message": "Minimal MCP Server", "status": "running"}

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.get("/mcp/info")
async def mcp_info():
    return {
        "name": "minimal-mcp-server",
        "version": "1.0.0",
        "description": "A minimal MCP server for Langflow tutorial"
    }

@app.get("/mcp/sse")
async def mcp_sse():
    return {"message": "SSE endpoint available"}

@app.head("/mcp/sse")
async def mcp_sse_head():
    return {"message": "SSE endpoint available"}

@app.post("/mcp/initialize")
async def mcp_initialize():
    return {
        "protocolVersion": "2024-11-05",
        "capabilities": {
            "tools": {}
        },
        "serverInfo": {
            "name": "minimal-mcp-server",
            "version": "1.0.0"
        }
    }

@app.post("/mcp/tools/list")
async def tools_list(request: Request = None):
    return {
        "jsonrpc": "2.0",
        "id": 1,
        "result": {
            "tools": TOOLS
        }
    }

@app.post("/mcp/tools/call")
async def tools_call(request: Request):
    try:
        data = await request.json()
        tool_name = data.get("params", {}).get("toolName")
        tool_args = data.get("params", {}).get("args", {})
        
        if tool_name == "echo_text":
            text = tool_args.get("text", "")
            result = {
                "content": [{"type": "text", "text": f"Echo: {text}"}]
            }
        elif tool_name == "add_numbers":
            a = tool_args.get("a", 0)
            b = tool_args.get("b", 0)
            result = {
                "content": [{"type": "text", "text": f"{a} + {b} = {a + b}"}]
            }
        elif tool_name == "describe_image":
            image_data = tool_args.get("image_data", "")
            # Decode base64 and analyze with real AI
            try:
                image_bytes = base64.b64decode(image_data)
                description = analyze_image_with_ai(image_bytes)
                result = {
                    "content": [{"type": "text", "text": f"🤖 AI Description: {description}"}]
                }
            except Exception as e:
                result = {
                    "content": [{"type": "text", "text": f"❌ Error analyzing image: {str(e)}"}]
                }
        elif tool_name == "find_item_in_image":
            image_data = tool_args.get("image_data", "")
            search_text = tool_args.get("search_text", "")
            # Decode base64 and find objects with real AI
            try:
                image_bytes = base64.b64decode(image_data)
                annotated_image_b64 = find_objects_in_image(image_bytes, search_text)
                result = {
                    "content": [{"type": "text", "text": f"🔍 Found '{search_text}' in image. Annotated image generated."}],
                    "annotated_image": annotated_image_b64
                }
            except Exception as e:
                result = {
                    "content": [{"type": "text", "text": f"❌ Error finding objects: {str(e)}"}]
                }
        else:
            result = {
                "content": [{"type": "text", "text": f"Unknown tool: {tool_name}"}]
            }
        
        return {
            "jsonrpc": "2.0",
            "id": data.get("id", 1),
            "result": result
        }
    except Exception as e:
        return {
            "jsonrpc": "2.0",
            "id": 1,
            "error": {
                "code": -32603,
                "message": f"Internal error: {str(e)}"
            }
        }

if __name__ == "__main__":
    print("🚀 Starting Minimal HTTP MCP Server on http://localhost:8002")
    uvicorn.run("mcp_server_minimal:app", host="0.0.0.0", port=8002, reload=False)
