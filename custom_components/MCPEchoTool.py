from langflow.field_typing import Data
from langflow.custom.custom_component.component import Component
from langflow.io import MessageTextInput, Output
from langflow.schema.data import Data
import requests
import json

class MCPEchoTool(Component):
    display_name = "MCP Echo Tool"
    description = "Echo any text back using MCP server"
    documentation: str = "https://docs.langflow.org/components-custom-components"
    icon = "message-circle"
    name = "MCPEchoTool"
    
    inputs = [
        MessageTextInput(
            name="text",
            display_name="Text to Echo",
            info="The text to echo back",
            value="Hello!",
            tool_mode=True
        ),
        MessageTextInput(
            name="proxy_url",
            display_name="Proxy URL",
            info="URL of the MCP proxy server",
            value="http://localhost:8003"
        )
    ]
    
    outputs = [
        Output(display_name="Result", name="result", method="echo_text"),
    ]
    
    def echo_text(self) -> Data:
        """Echo text using MCP server"""
        try:
            response = requests.get(
                f"{self.proxy_url}/echo",
                params={"text": self.text},
                timeout=10
            )
            response.raise_for_status()
            result = response.json()
            
            if "echo_result" in result:
                # Add clear tool identification
                tool_output = f"🔧 MCP Echo Tool: {result['echo_result']}"
                return Data(value=tool_output)
            else:
                return Data(value=str(result))
                
        except Exception as e:
            error_msg = f"❌ MCP Echo Tool error: {str(e)}"
            return Data(value=error_msg)