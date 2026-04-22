#!/bin/bash
cd "$(dirname "$0")"

# Skip dependency check if already installed before
if [ -f ".deps_installed" ]; then
    python3 gui.py &
    exit 0
fi

# Check if requirements.txt exists
if [ ! -f "requirements.txt" ]; then
    echo
    echo "  [WARNING] requirements.txt not found!"
    echo
    read -p "  Skip dependency install and launch directly? [Y/N]: " choice
    echo
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        python3 gui.py &
        exit 0
    fi
    echo "  Cancelled."
    exit 1
fi

# requirements.txt found, ask to install
echo
echo "  [OK] requirements.txt found."
echo
read -p "  Install dependencies? [Y/N]: " install
echo

if [[ "$install" =~ ^[Yy]$ ]]; then
    echo "  Installing dependencies, please wait..."
    echo
    pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
    if [ $? -ne 0 ]; then
        echo
        echo "  [ERROR] Installation failed! Check your network or pip config."
        exit 1
    fi
    echo
    echo "  [OK] Done! Will skip this step on next launch."
    touch .deps_installed
    echo
else
    touch .deps_installed
fi

# Launch
python3 gui.py &
exit 0
