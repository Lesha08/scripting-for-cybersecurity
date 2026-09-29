#!/bin/bash

CASE_DIR="case"
REPORT="triage-report-auto.txt"

read -p "Enter your analyst name: " ANALYST
read -p "Enter the case reference: " CASE_REF

PYTHON_FILES=$(find "$CASE_DIR" -type f -name "*.py" | wc -l)
SHELL_SCRIPTS=$(find "$CASE_DIR" -type f -name "*.sh" | wc -l)
LOG_FILES=$(find "$CASE_DIR" -type f -name "*.log" | wc -l)
CONFIG_FILES=$(find "$CASE_DIR" -type f -name "*.conf" | wc -l)
TOTAL_FILES=$(find "$CASE_DIR" -type f | wc -l)
TOTAL_DIRS=$(find "$CASE_DIR" -type d | wc -l)
EMPTY_FILES=$(find "$CASE_DIR" -type f -empty | wc -l)
ARCHIVES=$(find "$CASE_DIR" -type f -name "*.zip" | wc -l)

SCRIPTS=$((PYTHON_FILES + SHELL_SCRIPTS))

echo "TRIAGE REPORT" > "$REPORT"
echo "================" >> "$REPORT"
echo "Analyst: $ANALYST" >> "$REPORT"
echo "Case Reference: $CASE_REF" >> "$REPORT"
echo "Date: $(date)" >> "$REPORT"
echo "" >> "$REPORT"

echo "Total Files: $TOTAL_FILES" >> "$REPORT"
echo "Total Directories: $TOTAL_DIRS" >> "$REPORT"
echo "Python Files: $PYTHON_FILES" >> "$REPORT"
echo "Shell Scripts: $SHELL_SCRIPTS" >> "$REPORT"
echo "Log Files: $LOG_FILES" >> "$REPORT"
echo "Configuration Files: $CONFIG_FILES" >> "$REPORT"
echo "Empty Files: $EMPTY_FILES" >> "$REPORT"
echo "Archives: $ARCHIVES" >> "$REPORT"
echo "" >> "$REPORT"

echo "Files containing admin:" >> "$REPORT"
grep -rl "admin" "$CASE_DIR" >> "$REPORT"
echo "" >> "$REPORT"

echo "File types in evidence:" >> "$REPORT"
file "$CASE_DIR"/evidence/* >> "$REPORT"
echo "" >> "$REPORT"

echo "Scripts (Python + shell): $SCRIPTS" >> "$REPORT"

