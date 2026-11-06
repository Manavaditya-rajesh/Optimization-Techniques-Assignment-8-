# ==============================================================================
# Makefile - Optimization Techniques: Assignment 8 Master Build
# Author: Manavaditya Rajesh (Roll: 241070040)
# Course: Optimization Techniques (Instructor: Akhil) | VJTI
# ==============================================================================

.PHONY: all doctor setup trackA trackB trackC trackD trackE trackF trackG trackH trackI trackJ report pdf logs-pdf submission demo clean test-all

PYTHON ?= python3
SHELL  := /bin/bash

all: trackA trackB trackD trackE trackC trackI trackF trackJ trackH trackG
	@echo "=========================================================="
	@echo "All experimental tracks completed successfully."
	@echo "=========================================================="

# ------------------------------------------------------------------------------
# System Doctor: Check tools and dependencies
# ------------------------------------------------------------------------------
doctor:
	@echo "=========================================================="
	@echo "Running System Environment & Tool Doctor..."
	@echo "=========================================================="
	@$(PYTHON) -c "import sys; print(f'Python: {sys.version.split()[0]} (>= 3.11 required: {\"PASS\" if sys.version_info >= (3, 11) else \"FAIL\"})')"
	@echo -n "Git: "; which git 2>/dev/null && git --version || echo "MISSING"
	@echo -n "GCC: "; which gcc 2>/dev/null && gcc --version | head -n1 || echo "MISSING"
	@echo -n "QEMU (RISC-V): "; which qemu-system-riscv64 2>/dev/null && qemu-system-riscv64 --version | head -n1 || echo "MISSING (Needed for Track G xv6)"
	@echo -n "PostgreSQL Client: "; which psql 2>/dev/null && psql --version || echo "MISSING (Needed for Track H DBMS)"
	@echo -n "Pandoc: "; which pandoc 2>/dev/null && pandoc --version | head -n1 || echo "MISSING (Needed for Report PDF)"
	@echo -n "XeLaTeX: "; which xelatex 2>/dev/null && xelatex --version | head -n1 || echo "OPTIONAL / FALLBACK (WeasyPrint can be used)"
	@echo -n "WeasyPrint: "; which weasyprint 2>/dev/null && weasyprint --version || echo "OPTIONAL / FALLBACK"
	@echo "=========================================================="
	@echo "Checking Key Python Libraries..."
	@$(PYTHON) -c "\
pkgs = ['numpy', 'scipy', 'matplotlib', 'pandas', 'pulp', 'networkx', 'torch', 'qiskit', 'pennylane', 'pytest']; \
for p in pkgs: \
    try: \
        m = __import__(p); print(f'  [PASS] {p} ({getattr(m, \"__version__\", \"installed\")})') \
    except ImportError: \
        print(f'  [FAIL] {p} is NOT installed in active Python environment.')"
	@echo "=========================================================="
	@echo "Generating hardware & environment specification..."
	@$(PYTHON) hardware_info.py

# ------------------------------------------------------------------------------
# Individual Track Execution
# ------------------------------------------------------------------------------
trackA:
	@echo "=== Running Track A: Continuous Optimization ==="
	$(PYTHON) trackA_continuous/src/run_trackA.py

trackB:
	@echo "=== Running Track B: Discrete Optimization ==="
	$(PYTHON) trackB_discrete/src/run_trackB.py

trackC:
	@echo "=== Running Track C: Quantum Optimization (Simulated) ==="
	$(PYTHON) trackC_quantum_opt/src/run_trackC.py

trackD:
	@echo "=== Running Track D: Submodular, Parallel & Distributed ==="
	$(PYTHON) trackD_parallel_distributed/src/run_trackD.py

trackE:
	@echo "=== Running Track E: Waste Collection CVRP Case Study ==="
	$(PYTHON) trackE_case_study/src/run_trackE.py

trackF:
	@echo "=== Running Track F: Toy Compiler Optimizations & RegAlloc ==="
	$(PYTHON) trackF_compiler/src/run_trackF.py

trackG:
	@echo "=== Running Track G: xv6 MLFQ & CoW Benchmarks ==="
	@if [ -f trackG_xv6/src/run_trackG.sh ]; then \
		bash trackG_xv6/src/run_trackG.sh; \
	else \
		$(PYTHON) trackG_xv6/src/benchmark_xv6.py; \
	fi

trackH:
	@echo "=== Running Track H: PostgreSQL Index Selection ==="
	$(PYTHON) trackH_dbms/src/run_trackH.py

trackI:
	@echo "=== Running Track I: Quantum Algorithms & QML ==="
	$(PYTHON) trackI_quantum_algos/src/run_trackI.py

trackJ:
	@echo "=== Running Track J: Test-Suite Minimization & Prioritization ==="
	$(PYTHON) trackJ_software_eng/src/run_trackJ.py

# ------------------------------------------------------------------------------
# Test Execution
# ------------------------------------------------------------------------------
test-all:
	pytest -v */tests/

# ------------------------------------------------------------------------------
# Report & PDF Compilation
# ------------------------------------------------------------------------------
report:
	@echo "=== Injecting Measured Metrics into Technical Report ==="
	@if command -v $(PYTHON) &>/dev/null; then \
		$(PYTHON) report/fill_report.py || node fill_all_placeholders.js; \
	else \
		node fill_all_placeholders.js; \
	fi

pdf: report
	@echo "=== Compiling Technical Report PDF ==="
	@if command -v bash &>/dev/null && command -v pandoc &>/dev/null; then \
		bash report/build_pdf.sh report/report.md report/OT_Assignment_8_Report.pdf || node build_full_pdf.js; \
	else \
		node build_full_pdf.js; \
	fi

logs-pdf:
	@echo "=== Compiling Prompt Logs and AI Register PDF ==="
	@if command -v bash &>/dev/null && command -v pandoc &>/dev/null; then \
		bash report/build_pdf.sh docs/prompts_and_logs.md prompts_and_logs.pdf || node build_full_pdf.js; \
	else \
		node build_full_pdf.js; \
	fi

submission: pdf logs-pdf
	@echo "=== Assembling Submission Deliverables in Root ==="
	cp report/OT_Assignment_8_Report.pdf ./OT_Assignment_8_Report.pdf
	@echo "[+] Submission PDFs successfully generated in repository root."

demo:
	@echo "=== Running 5-Minute Fast Demo Subset Across Tracks ==="
	$(PYTHON) docs/fast_demo.py

clean:
	rm -rf __pycache__ */__pycache__ */*/__pycache__
	rm -rf .pytest_cache */.pytest_cache
	rm -f /tmp/report_temp.html /tmp/pandoc_xelatex.err
