#!/bin/bash
# setup.sh - Initial setup for Langflow tutorial
# This script sets up the virtual environment and installs all dependencies

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

echo -e "${BLUE}🚀 Langflow Tutorial Setup${NC}"
echo "=============================="

# Check Python version
echo -e "${YELLOW}🐍 Checking Python version...${NC}"
python_version=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
required_version="3.8"

if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" = "$required_version" ]; then
    echo -e "${GREEN}✅ Python $python_version is compatible${NC}"
else
    echo -e "${RED}❌ Python $python_version is not compatible. Need Python 3.8+${NC}"
    exit 1
fi

# Create virtual environment
echo -e "${YELLOW}📦 Creating virtual environment...${NC}"
if [ -d "venv" ]; then
    echo -e "${YELLOW}⚠️  Virtual environment already exists. Removing old one...${NC}"
    rm -rf venv
fi

python3 -m venv venv
echo -e "${GREEN}✅ Virtual environment created${NC}"

# Activate virtual environment
echo -e "${YELLOW}🔄 Activating virtual environment...${NC}"
source venv/bin/activate
echo -e "${GREEN}✅ Virtual environment activated${NC}"

# Upgrade pip
echo -e "${YELLOW}⬆️  Upgrading pip...${NC}"
pip install --upgrade pip
echo -e "${GREEN}✅ Pip upgraded${NC}"

# Install dependencies
echo -e "${YELLOW}📚 Installing dependencies...${NC}"
echo "This may take a few minutes..."

# Core dependencies
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
pip install transformers
pip install fastapi uvicorn
pip install pillow
pip install ultralytics
pip install opencv-python
pip install requests
pip install numpy

echo -e "${GREEN}✅ All dependencies installed${NC}"

# Create requirements.txt for future use
echo -e "${YELLOW}📝 Creating requirements.txt...${NC}"
pip freeze > requirements.txt
echo -e "${GREEN}✅ requirements.txt created${NC}"

# Make scripts executable
echo -e "${YELLOW}🔧 Making scripts executable...${NC}"
chmod +x start_servers.sh
chmod +x stop_servers.sh
chmod +x check_servers.sh
chmod +x setup.sh
echo -e "${GREEN}✅ Scripts made executable${NC}"

# Test installation
echo -e "${YELLOW}🧪 Testing installation...${NC}"
python -c "import torch; print(f'PyTorch: {torch.__version__}')"
python -c "import transformers; print(f'Transformers: {transformers.__version__}')"
python -c "import fastapi; print(f'FastAPI: {fastapi.__version__}')"
python -c "import PIL; print(f'Pillow: {PIL.__version__}')"
python -c "import requests; print(f'Requests: {requests.__version__}')"
echo -e "${GREEN}✅ All packages working correctly${NC}"

echo ""
echo -e "${GREEN}🎉 Setup completed successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo "  1. Start the servers:     ./start_servers.sh"
echo "  2. Check server status:   ./check_servers.sh"
echo "  3. Open Langflow Desktop"
echo "  4. Follow the tutorial:   TUTORIAL_GUIDE.md"
echo ""
echo -e "${BLUE}🛠️  Management Commands:${NC}"
echo "  • Start servers:  ./start_servers.sh"
echo "  • Stop servers:   ./stop_servers.sh"
echo "  • Check status:   ./check_servers.sh"
echo "  • View logs:      tail -f *.log"
echo ""
echo -e "${YELLOW}💡 Optional: Install Ollama for local LLM demos${NC}"
echo "  Visit: https://ollama.ai/ and follow installation instructions"
echo "  Then run: ollama pull llama3.2"
echo ""
echo -e "${GREEN}Ready to start learning Langflow! 🚀${NC}"
