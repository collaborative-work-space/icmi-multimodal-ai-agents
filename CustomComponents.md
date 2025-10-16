# Custom Components for Langflow MCP Integration

## 🎯 Overview

This document explains the custom components created to enable MCP (Model Context Protocol) integration with Langflow. These components provide a bridge between Langflow's visual interface and MCP servers, allowing you to use external tools and services in your workflows.

## 🏗️ Architecture

### MCP Proxy Architecture

The custom components use a proxy architecture to bridge Langflow and MCP servers:

```
Langflow Custom Component → MCP Proxy (Port 8003) → MCP Server (Port 8002)
```

**Why a Proxy?**
- Langflow expects single JSON responses, not streaming SSE
- MCP servers use streaming Server-Sent Events (SSE)
- The proxy translates between these two protocols
- Provides a clean, simple interface for custom components

## 📦 Available Custom Components

### 1. MCPEchoTool
**Purpose**: Echo text using MCP server - for Agent use

**Configuration**:
- **Text to Echo**: Any text you want to echo back
- **Proxy URL**: `http://localhost:8003` (MCP Proxy server)

**Usage**: Connect to Agent as a tool for basic text operations

### 2. MCPAddTool
**Purpose**: Add two numbers using MCP server - for Agent use

**Configuration**:
- **First Number**: First number to add
- **Second Number**: Second number to add
- **Proxy URL**: `http://localhost:8003` (MCP Proxy server)

**Usage**: Connect to Agent as a tool for mathematical operations

### 3. MCPImageAnnotator
**Purpose**: Image processing and annotation using MCP tools

**Configuration**:
- **Image File**: Connect from FileInput
- **Search Text**: Comma-separated list of items to find (e.g., "person, car, tree")
- **Proxy URL**: `http://localhost:8003` (MCP Proxy server)

**Usage**: Process images and call MCP tools for analysis


## 🔧 How to Use Custom Components

### Step 1: Install Custom Components

1. **Open Langflow Desktop**
2. **Go to Components Panel**
3. **Click "Custom Components"**
4. **Click "Create Component"**
5. **Copy and paste the component code**
6. **Save the component**

### Step 2: Configure Components

1. **Drag the component** from the custom components panel
2. **Configure the parameters**:
   - Set the Proxy URL to `http://localhost:8003`
   - Configure tool-specific parameters
3. **Connect to other components** as needed

### Step 3: Connect to Agent

1. **Drag an Agent component** to your flow
2. **Connect custom components** to the Agent's tools input
3. **Configure the Agent** with appropriate system message

## 🚀 Example Workflows

### Basic MCP Integration (Example 3)
```
ChatInput → Agent → ChatOutput
           ↑
    MCPEchoTool + MCPAddTool
```



## 🔍 Troubleshooting

### Common Issues

1. **"Component not found"**:
   - Ensure custom components are properly installed
   - Check Langflow Desktop version compatibility

2. **"Connection failed"**:
   - Ensure MCP servers are running: `./check_servers.sh`
   - Check proxy URL configuration

3. **"Tool call failed"**:
   - Verify tool name and arguments
   - Check MCP server logs

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

## 📚 Key Concepts

### Custom Component Structure
- **Inherit from Component**: All custom components inherit from Langflow's Component class
- **Define Inputs**: Specify input parameters with types and validation
- **Define Outputs**: Specify output data with methods
- **Implement Logic**: Write the component's functionality in the build method

### MCP Integration
- **HTTP Communication**: Components make HTTP requests to the proxy
- **JSON-RPC Protocol**: MCP uses JSON-RPC 2.0 for communication
- **Error Handling**: Graceful handling of network and tool errors
- **Data Conversion**: Converting between Langflow and MCP data formats

### Agent Integration
- **Tool Connection**: Custom components connect to Agent as tools
- **Tool Discovery**: Agent automatically discovers available tools
- **Tool Calling**: Agent calls tools based on user input and context

## 🎯 Best Practices

### Component Design
- **Single Responsibility**: Each component should have one clear purpose
- **Error Handling**: Always handle errors gracefully
- **Input Validation**: Validate inputs before processing
- **Clear Documentation**: Provide clear descriptions and examples

### MCP Integration
- **Use Proxy**: Always use the proxy for MCP communication
- **Handle Errors**: Implement proper error handling for network issues
- **Validate Responses**: Check MCP responses before processing
- **Log Debugging**: Include logging for troubleshooting

### Workflow Design
- **Modular Components**: Use small, focused components
- **Clear Connections**: Make component connections clear and logical
- **Error Recovery**: Design workflows to handle component failures
- **User Feedback**: Provide clear feedback to users

## 🔮 Future Enhancements

### Planned Features
- **More MCP Tools**: Support for additional MCP tools
- **Resource Management**: Components for MCP resource handling
- **Batch Processing**: Components for processing multiple items
- **Advanced Error Handling**: More sophisticated error recovery

### Customization
- **Tool Configuration**: Easy configuration of MCP tools
- **Custom Tool Creation**: Tools for creating custom MCP tools
- **Workflow Templates**: Pre-built workflow templates
- **Component Library**: Extended library of custom components

## 📁 File Structure

```
custom_components/
├── MCPEchoTool.py          # Echo text tool
└── MCPAddTool.py           # Add numbers tool
```

## 🤝 Contributing

### Adding New Components
1. **Create component file** in `custom_components/`
2. **Follow naming convention** (e.g., `MCPToolName.py`)
3. **Inherit from Component** class
4. **Implement required methods**
5. **Add documentation** and examples
6. **Test thoroughly** with MCP servers

### Component Template
```python
from langflow.field_typing import Data
from langflow.custom.custom_component.component import Component
from langflow.io import MessageTextInput, Output
from langflow.schema.data import Data
import requests
import json

class YourMCPTool(Component):
    display_name = "Your MCP Tool"
    description = "Description of what this tool does"
    documentation: str = "https://docs.langflow.org/components-custom-components"
    icon = "tool-icon"
    name = "YourMCPTool"
    
    inputs = [
        MessageTextInput(
            name="input_param",
            display_name="Input Parameter",
            info="Description of the input parameter",
            value="default_value"
        ),
        MessageTextInput(
            name="proxy_url",
            display_name="Proxy URL",
            info="URL of the MCP proxy server",
            value="http://localhost:8003"
        )
    ]
    
    outputs = [
        Output(display_name="Result", name="result", method="build_result"),
    ]
    
    def build_result(self) -> Data:
        try:
            # Your MCP tool logic here
            response = requests.post(
                f"{self.proxy_url}/call",
                json={
                    "tool_name": "your_tool_name",
                    "args": {"param": self.input_param}
                },
                timeout=10
            )
            response.raise_for_status()
            result = response.json()
            
            if "result" in result and "content" in result["result"]:
                return Data(value=result["result"]["content"][0]["text"])
            else:
                return Data(value=str(result))
                
        except Exception as e:
            error_msg = f"Error calling MCP tool: {str(e)}"
            return Data(value=error_msg)
```

## 📞 Support

### Getting Help
- **Check server logs** for error details
- **Verify server status** with `./check_servers.sh`
- **Test MCP servers** directly with curl commands
- **Review component configuration** in Langflow

### Common Solutions
- **Restart servers** if they're not responding
- **Check proxy URL** configuration
- **Verify tool names** and arguments
- **Ensure proper component connections**

This documentation provides a comprehensive guide to using custom components for MCP integration with Langflow. The components enable powerful external tool integration while maintaining the simplicity and visual appeal of Langflow's interface.
