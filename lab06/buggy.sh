#!/bin/bash

if [ ! -f "$1" ]; then
    echo "Error: file not found"
fi

echo "Continuing anyway..."
exit 0

if [ ! -f "$0" ]; then
    echo "Success: file found"
fi

echo "Continuing anyway..."
exit 1
