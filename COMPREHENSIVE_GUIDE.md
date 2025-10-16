# 🚀 Langflow MCP Integration - Comprehensive Guide

## 🎯 Overview

This comprehensive guide covers everything you need to know about using Langflow with MCP (Model Context Protocol) integration. It combines setup instructions, component guides, flow building, and troubleshooting in one place.

## 📋 Table of Contents

1. [Quick Start](#-quick-start)
2. [MCP Server Management](#-mcp-server-management)
3. [Custom Components](#-custom-components)
4. [Flow Building Guide](#-flow-building-guide)
5. [Tutorial Examples](#-tutorial-examples)
6. [Troubleshooting](#-troubleshooting)
7. [Reference](#-reference)

## 🚀 Quick Start

### Prerequisites
- **Langflow Desktop 1.6.0** installed and running
- **Python 3.8+** installed
- **Ollama** installed (for local LLM examples)

### One-Command Setup
```bash
# Clone or download the project
cd /path/to/LangFlow

# Run the setup script (first time only)
./setup.sh

# Start all MCP servers
./start_servers.sh

# Open Langflow Desktop and start building!
```

### Essential Commands
```bash
# Start all servers
./start_servers.sh

# Check server status
./check_servers.sh

# Stop all servers
./stop_servers.sh

# View server logs
tail -f *.log
```

## 🛠️ MCP Server Management

### Server Architecture
```
Langflow Custom Component → MCP Proxy (Port 8003) → MCP Server (Port 8002)
```

### Available Servers
- **Minimal MCP Server** (Port 8002): Basic MCP tools (echo, add, image tools)
- **MCP Proxy** (Port 8003): Langflow compatibility layer

### Server Commands

#### Start Servers
```bash
./start_servers.sh
```
- Starts both MCP server and proxy
- Activates virtual environment
- Checks dependencies
- Provides status information

#### Check Status
```bash
./check_servers.sh
```
- Shows server status (running/stopped)
- Displays port information
- Shows memory usage
- Performs connectivity tests

#### Stop Servers
```bash
./stop_servers.sh
```
- Gracefully stops all servers
- Cleans up PID files
- Preserves log files for debugging

### Server URLs
- **Minimal MCP Server**: http://localhost:8002
- **MCP Proxy**: http://localhost:8003
- **Health Check**: http://localhost:8003/health
- **Tools List**: http://localhost:8003/tools

## 🔧 Custom Components

### Available Components

#### 1. MCPEchoTool
**Purpose**: Echo text using MCP server
**Configuration**:
- Text to Echo: Any text
- Proxy URL: http://localhost:8003

#### 2. MCPAddTool
**Purpose**: Add two numbers using MCP server
**Configuration**:
- First Number: First number
- Second Number: Second number
- Proxy URL: http://localhost:8003

#### 3. MCPImageAnnotator
**Purpose**: Image processing and annotation
**Configuration**:
- Image File: Connect from FileInput
- Search Text: Comma-separated items to find
- Proxy URL: http://localhost:8003

#### 4. MCPToolCaller
**Purpose**: Generic MCP tool access
**Configuration**:
- Tool Name: Name of MCP tool to call
- Tool Arguments: Arguments for the tool
- Proxy URL: http://localhost:8003

### Installing Custom Components

1. **Open Langflow Desktop**
2. **Go to Components Panel**
3. **Click "Custom Components"**
4. **Click "Create Component"**
5. **Copy and paste component code**
6. **Save the component**

## 🏗️ Flow Building Guide

### Basic Flow Structure
```
Input → Processing → Output
```

### Component Categories

#### Input Components
| Component | Purpose | Output Type |
|-----------|---------|-------------|
| `ChatInput` | Text input from user | `str` |
| `FileInput` | File upload | `File` |

#### Processing Components
| Component | Purpose | Input Type | Output Type |
|-----------|---------|------------|-------------|
| `PromptTemplate` | Text processing | `str` | `str` |
| `OllamaModel` | LLM processing | `str` | `str` |
| `Agent` | AI agent with tools | `str` + tools | `str` |
| `MCPEchoTool` | Echo text via MCP | `str` | `str` |
| `MCPAddTool` | Add numbers via MCP | `str` | `str` |
| `MCPImageAnnotator` | Image processing via MCP | `File` | `str` |
| `MCPToolCaller` | Generic MCP tool access | `str` | `str` |

#### Output Components
| Component | Purpose | Input Type |
|-----------|---------|------------|
| `ChatOutput` | Display text output | `str` |

### Connection Rules
- **Input → Processing**: Connect data flow
- **Processing → Output**: Connect results
- **Tools → Agent**: Connect custom components as tools
- **LLM → Agent**: Connect language model to agent

## 📚 Tutorial Examples

### Example 1: Simple Text Echo Flow
**Purpose**: Learn basic Langflow concepts

**Components**: ChatInput → PromptTemplate → ChatOutput

**What you learn**:
- Basic component connections
- Text processing
- Input/output handling

### Example 2: Basic LLM Flow
**Purpose**: Integrate language models

**Components**: ChatInput → OllamaModel → ChatOutput

**What you learn**:
- LLM integration
- Model configuration
- Response generation

### Example 3: MCP Integration
**Purpose**: Use MCP tools with custom components

**Components**: ChatInput → Agent → ChatOutput
**Tools**: MCPEchoTool + MCPAddTool

**What you learn**:
- Custom components
- MCP proxy architecture
- Agent with tools

### Example 4: Image Annotation
**Purpose**: Process images with MCP tools

**Components**: FileInput → MCPImageAnnotator → Agent → ChatOutput

**What you learn**:
- Image processing
- MCP image tools
- Complex workflows

### Example 5: Advanced Tool Access
**Purpose**: Generic MCP tool access

**Components**: FileInput → MCPToolCaller → Agent → ChatOutput

**What you learn**:
- Generic tool access
- Advanced MCP integration
- Flexible workflows

## 🔧 Troubleshooting

### Common Issues

#### 1. "Component not found"
**Solution**:
- Ensure custom components are properly installed
- Check Langflow Desktop version compatibility
- Restart Langflow Desktop

#### 2. "Connection failed"
**Solution**:
- Check if MCP servers are running: `./check_servers.sh`
- Verify proxy URL configuration
- Check network connectivity

#### 3. "Tool call failed"
**Solution**:
- Verify tool name and arguments
- Check MCP server logs
- Ensure proper component connections

#### 4. "Server not responding"
**Solution**:
- Restart servers: `./stop_servers.sh && ./start_servers.sh`
- Check port availability
- View server logs for errors

### Debug Steps

1. **Check server status**:
   ```bash
   ./check_servers.sh
   ```

2. **View server logs**:
   ```bash
   tail -f mcp_server_minimal.log
   tail -f mcp_proxy.log
   ```

3. **Test MCP servers directly**:
   ```bash
   curl -X POST http://localhost:8002/mcp/tools/list
   curl http://localhost:8003/tools
   ```

4. **Test specific tool calls**:
   ```bash
   curl -X POST http://localhost:8003/call \
     -H "Content-Type: application/json" \
     -d '{"tool_name": "echo_text", "args": {"text": "test"}}'
   ```

## 📖 Reference

### MCP Server Endpoints

#### Minimal MCP Server (Port 8002)
- **Health**: `GET /health`
- **Tools List**: `POST /mcp/tools/list`
- **Tool Call**: `POST /mcp/tools/call`
- **SSE**: `GET /mcp/sse`

#### MCP Proxy (Port 8003)
- **Health**: `GET /health`
- **Tools List**: `GET /tools`
- **Tool Call**: `POST /call`
- **Echo**: `GET /echo?text=...`

### Available MCP Tools

#### Basic Tools
- **echo_text**: Echo back any text
- **add_numbers**: Add two numbers

#### Image Tools
- **describe_image**: Describe an image from base64 data
- **find_item_in_image**: Find specific items in an image

### Component Configuration

#### MCPEchoTool
```python
inputs = [
    MessageTextInput(
        name="text",
        display_name="Text to Echo",
        value="Hello!"
    ),
    MessageTextInput(
        name="proxy_url",
        display_name="Proxy URL",
        value="http://localhost:8003"
    )
]
```

#### MCPAddTool
```python
inputs = [
    MessageTextInput(
        name="a",
        display_name="First Number",
        value="5"
    ),
    MessageTextInput(
        name="b",
        display_name="Second Number",
        value="3"
    ),
    MessageTextInput(
        name="proxy_url",
        display_name="Proxy URL",
        value="http://localhost:8003"
    )
]
```

### File Structure
```
LangFlow/
├── custom_components/          # Custom component files
│   ├── MCPEchoTool.py
│   ├── MCPAddTool.py
│   ├── MCPImageAnnotator.py
│   ├── MCPToolCaller.py
│   ├── ImageLoader.py
│   ├── ImageLoaderAdvanced.py
│   └── ResourceViewer.py
├── mcp_server_minimal.py       # Minimal MCP server
├── mcp_server_basic.py         # Basic MCP server
├── mcp_server_advanced.py      # Advanced MCP server
├── mcp_proxy.py               # MCP proxy server
├── start_servers.sh           # Start all servers
├── stop_servers.sh            # Stop all servers
├── check_servers.sh           # Check server status
├── setup.sh                   # Initial setup
├── Tutorial_Example_1.md      # Tutorial examples
├── Tutorial_Example_2.md
├── Tutorial_Example_3.md
├── Tutorial_Example_4.md
├── Tutorial_Example_5.md
├── COMPREHENSIVE_GUIDE.md     # This guide
├── CustomComponents.md        # Custom components guide
├── README.md                  # Project overview
└── venv/                      # Python virtual environment
```

## 🎯 Next Steps

### Learning Path
1. **Start with Example 1**: Learn basic Langflow concepts
2. **Progress through Examples**: Build complexity gradually
3. **Experiment with Components**: Try different configurations
4. **Create Custom Workflows**: Apply what you've learned
5. **Build Custom Components**: Extend functionality

### Advanced Topics
- **Custom Component Development**: Create your own components
- **MCP Server Development**: Build custom MCP servers
- **Workflow Optimization**: Improve performance and reliability
- **Integration Patterns**: Connect to other services

### Resources
- **Langflow Documentation**: https://docs.langflow.org
- **MCP Specification**: https://modelcontextprotocol.io
- **Custom Components Guide**: See CustomComponents.md
- **Tutorial Examples**: See Tutorial_Example_*.md files

## 🤝 Support

### Getting Help
- **Check this guide** for common solutions
- **Review server logs** for error details
- **Test components** individually
- **Verify configurations** step by step

### Contributing
- **Report issues** with detailed logs
- **Suggest improvements** for components
- **Share workflows** with the community
- **Contribute code** for new features

This comprehensive guide provides everything you need to successfully use Langflow with MCP integration. Start with the Quick Start section and progress through the examples to build your understanding and skills.
