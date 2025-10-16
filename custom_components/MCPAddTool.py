from langflow.field_typing import Data
from langflow.custom.custom_component.component import Component
from langflow.io import MessageTextInput, Output, IntInput
from langflow.schema.data import Data
import requests
import json

class MCPAddTool(Component):
    display_name = "MCP Add Tool"
    description = "Add two numbers together using MCP server"
    documentation: str = "https://docs.langflow.org/components-custom-components"
    icon = "calculator"
    name = "MCPAddTool"
    
    inputs = [
        IntInput(
            name="a",
            display_name="First Number",
            info="The first number to add",
            value=5,
            tool_mode=True
        ),
        IntInput(
            name="b",
            display_name="Second Number",
            info="The second number to add",
            value=3,
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
        Output(display_name="Result", name="result", method="add_numbers"),
    ]
    
    def add_numbers(self) -> Data:
        """Add two numbers using MCP server"""
        try:
            # Inputs are already integers, no conversion needed
            response = requests.post(
                f"{self.proxy_url}/call",
                params={"tool_name": "add_numbers"},
                json={"a": self.a, "b": self.b},
                timeout=10
            )
            response.raise_for_status()
            result = response.json()
            
            if "result" in result and "content" in result["result"]:
                # Add clear tool identification
                tool_output = f"🔧 MCP Add Tool: {result['result']['content'][0]['text']}"
                return Data(value=tool_output)
            else:
                return Data(value=str(result))
                
        except Exception as e:
            error_msg = f"❌ MCP Add Tool error: {str(e)}"
            return Data(value=error_msg)
