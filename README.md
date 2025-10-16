# 🎓 Langflow Tutorial: From Basics to Advanced MCP Integration

A comprehensive tutorial for learning Langflow with Model Context Protocol (MCP) integration, featuring custom components and image annotation workflows.

## 🚀 Quick Start

### Prerequisites
- **Langflow Desktop 1.6.0** - Download from [langflow.org](https://langflow.org)
- **Python 3.8+** 
- **Git**

### One-Command Setup
```bash
# Clone and setup everything
git clone <your-repo-url>
cd LangFlow
./setup.sh

# Start MCP servers
./start_servers.sh

# Open Langflow Desktop and start learning!
```

That's it! The setup script handles everything automatically.

## 📚 What You'll Learn

### Individual Tutorial Examples
- **[Tutorial Example 1](Tutorial_Example_1.md)**: Simple text echo flow
- **[Tutorial Example 2](Tutorial_Example_2.md)**: Basic LLM integration
- **[Tutorial Example 3](Tutorial_Example_3.md)**: MCP integration with custom components

### Complete Documentation
- **[COMPREHENSIVE_GUIDE.md](COMPREHENSIVE_GUIDE.md)** - Complete guide covering everything
- **[CustomComponents.md](CustomComponents.md)** - Detailed custom components documentation

## 🛠️ Management Commands

| Command | Purpose |
|---------|---------|
| `./setup.sh` | Initial setup (run once) |
| `./start_servers.sh` | Start all MCP servers |
| `./check_servers.sh` | Check server status |
| `./stop_servers.sh` | Stop all servers |

## 📖 Documentation

### Main Guides
- **[COMPREHENSIVE_GUIDE.md](COMPREHENSIVE_GUIDE.md)** - Complete guide covering everything
- **[CustomComponents.md](CustomComponents.md)** - Detailed custom components documentation

## 🧩 Custom Components

Ready-to-use components for MCP integration:

- **MCPEchoTool** - Echo text using MCP server (Example 3)
- **MCPAddTool** - Add two numbers using MCP server (Example 3)

## 🌐 MCP Servers

Two MCP servers with proxy architecture:

- **Minimal MCP Server** - Port 8002, basic MCP tools
- **MCP Proxy** - Port 8003, Langflow compatibility layer

## 🎯 Learning Path

### For Beginners
1. Start with **Example 1** - Learn basic Langflow concepts
2. Try **Example 2** - Understand LLM integration
3. Explore **Example 3** - Learn MCP integration with custom components

### For Advanced Users
1. Jump to **Example 4** - Image processing with custom components
2. Study **Example 5** - Advanced tool access
3. Explore **Custom Components** - Learn component development

## 🔧 Troubleshooting

### Quick Fixes
```bash
# Check server status
./check_servers.sh

# Restart servers
./stop_servers.sh
./start_servers.sh

# Re-run setup
./setup.sh
```

### Common Issues
- **Port conflicts**: Use `./check_servers.sh` to see what's using ports
- **Missing dependencies**: Run `./setup.sh` again
- **Server not responding**: Check logs with `tail -f *.log`

## 🎓 Educational Value

This tutorial teaches:

1. **Langflow Fundamentals** - Visual workflow building
2. **MCP Integration** - External tool communication
3. **Custom Component Development** - Building reusable components
4. **Image Processing** - Computer vision workflows
5. **Resource Management** - Data sharing between components
6. **Professional Practices** - Error handling, validation, automation

## 🚀 What's Next?

After completing this tutorial, you'll be able to:

- ✅ Build complex Langflow applications
- ✅ Integrate external tools via MCP
- ✅ Create custom components
- ✅ Build image annotation workflows
- ✅ Use MCP resource sharing
- ✅ Troubleshoot common issues
- ✅ Apply professional development practices

## 📊 Project Structure

```
LangFlow/
├── 📚 Documentation
│   ├── COMPREHENSIVE_GUIDE.md     # Complete guide
│   ├── CustomComponents.md        # Custom components guide
│   ├── README.md                  # This file
│   └── Tutorial_Example_*.md      # Individual tutorials
├── 🛠️ Management Scripts
│   ├── setup.sh                   # One-command setup
│   ├── start_servers.sh           # Start all servers
│   ├── stop_servers.sh            # Stop all servers
│   └── check_servers.sh           # Health monitoring
├── 🧩 Custom Components
│   ├── MCPEchoTool.py             # Echo text via MCP (Example 3)
│   └── MCPAddTool.py              # Add numbers via MCP (Example 3)
├── 🌐 MCP Servers
│   ├── mcp_server_minimal.py      # Minimal MCP server
│   ├── mcp_server_basic.py        # Basic MCP server
│   ├── mcp_server_advanced.py     # Advanced MCP server
│   └── mcp_proxy.py               # MCP proxy server
└── ⚙️ Environment
    └── venv/                      # Python virtual environment
```

## 🤝 Contributing

This tutorial is designed for educational purposes. Feel free to:

- Add new examples
- Improve existing components
- Enhance documentation
- Report issues
- Suggest improvements

## 📄 License

This project is part of the CSIRO ACM ICMI 2025 research initiative.

---

**Ready to start your Langflow journey?** 🚀

Run `./setup.sh` and begin with the [COMPREHENSIVE_GUIDE.md](COMPREHENSIVE_GUIDE.md)!
