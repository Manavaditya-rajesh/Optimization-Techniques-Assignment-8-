#!/usr/bin/env bash
# ==============================================================================
# setup_repo.sh - Bootstrap Script for OT-Assignment-8
# Author: Manavaditya Rajesh (Roll: 241070040)
# Course: Optimization Techniques (Instructor: Akhil) | VJTI
# ==============================================================================
set -euo pipefail

echo "=========================================================="
echo "Initializing OT-Assignment-8 Directory Structure..."
echo "=========================================================="

# Create track directories
TRACKS=(
  "trackA_continuous"
  "trackB_discrete"
  "trackC_quantum_opt"
  "trackD_parallel_distributed"
  "trackE_case_study"
  "trackF_compiler"
  "trackG_xv6"
  "trackH_dbms"
  "trackI_quantum_algos"
  "trackJ_software_eng"
)

for t in "${TRACKS[@]}"; do
  mkdir -p "$t/src" "$t/tests"
  echo "  [+] Created directory $t (src/, tests/)"
done

# Create supporting directories
mkdir -p patches
mkdir -p results/figures
mkdir -p report
mkdir -p docs

# Create prompts sub-folders
for t in "${TRACKS[@]}"; do
  short_track=$(echo "$t" | cut -d'_' -f1)
  mkdir -p "prompts/$short_track/screenshots"
  echo "  [+] Created prompts/$short_track/screenshots"
done

echo "=========================================================="
echo "Directory tree initialized successfully."
echo "=========================================================="
