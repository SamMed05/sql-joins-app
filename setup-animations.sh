#!/bin/bash
# Quick Start - Generate Manim Animations
# Bash script for Linux/Mac users

set -e  # Exit on error

echo "=================================================================="
echo "  SQL Joins Manim Animation Generator"
echo "=================================================================="
echo ""

# Check if Python is installed
echo "Checking Python installation..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✓ Found: $PYTHON_VERSION"
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_VERSION=$(python --version)
    echo "✓ Found: $PYTHON_VERSION"
    PYTHON_CMD="python"
else
    echo "✗ Python not found!"
    echo "  Please install Python from https://www.python.org/downloads/"
    exit 1
fi

# Check if pip is available
echo "Checking pip..."
if command -v pip3 &> /dev/null; then
    echo "✓ pip is available"
    PIP_CMD="pip3"
elif command -v pip &> /dev/null; then
    echo "✓ pip is available"
    PIP_CMD="pip"
else
    echo "✗ pip not found!"
    exit 1
fi

# Navigate to manim_scripts directory
echo ""
echo "Navigating to manim_scripts directory..."
cd manim_scripts

# Install requirements
echo ""
echo "Installing Manim and dependencies..."
echo "(This may take a few minutes on first run)"
$PIP_CMD install -r requirements.txt
echo "✓ Dependencies installed"

# Generate animations
echo ""
echo "Generating animations..."
echo "(This will take several minutes)"
$PYTHON_CMD generate_all.py
echo "✓ Animations generated successfully!"

# Return to project root
cd ..

echo ""
echo "=================================================================="
echo "  ✓ Setup Complete!"
echo "=================================================================="
echo ""
echo "To run the application:"
echo "  pnpm install"
echo "  pnpm run dev"
echo ""
echo "Then visit http://localhost:5173 and click on join types to see animations!"
echo ""
