# Assignment 8 – Optimize Anything: The 14-Day Vibe-Coding Challenge

**Course:** Optimization Techniques  
**Programme:** TY B.Tech Computer Engineering (Third Year, Semester 5)  
**Institute:** Veermata Jijabai Technological Institute (VJTI), Mumbai  
**Student Name:** Manavaditya Rajesh  
**Registration Number:** 241070040  
**Roll Number:** 241070040  
**Instructor:** Akhil  
**Submission Type:** Individual  
**GitHub Repository:** [https://github.com/Manavaditya-rajesh/OT-Assignment-8](https://github.com/Manavaditya-rajesh/OT-Assignment-8)  

---

## Executive Overview

This repository contains the complete experimental code, automated test suites, mathematical formulations, empirical results, and technical report for **Assignment 8: Optimize Anything (The 14-Day Vibe-Coding Challenge)**. 

The submission addresses all ten compulsory tracks (A through J), covering continuous, discrete, quantum, parallel, operating systems (xv6), compiler optimization, database management systems (PostgreSQL 16), and software engineering test suite minimization. A primary case study (Track E) focuses on Capacitated Vehicle Routing for municipal municipal solid waste collection.

All AI-assisted ("vibe-coding") interactions are documented transparently under `prompts/` and `docs/`, including prompt iterations, failure logs, and multi-tool evaluations.

---

## Repository Map

```
OT-Assignment-8/
├── Makefile                      # Master automation targets: doctor, all, track[A-J], report, pdf, demo
├── requirements.txt              # Pinned Python dependencies
├── hardware_info.py              # Environment inspector generating results/environment.md
├── hardware_info.sh              # Shell wrapper for environment inspection
├── setup_repo.sh                 # Bootstrap script
├── LICENSE                       # MIT License
├── .gitignore                    # Build artifact exclusions
├── patches/
│   └── xv6_changes.patch         # Git diff patch for xv6-riscv MLFQ & CoW features
├── trackA_continuous/            # Track A: First & second-order continuous optimizers & MLP backprop
│   ├── README.md
│   ├── src/ (optimizers.py, mlp_backprop.py, curvature.py, run_trackA.py)
│   └── tests/ (test_continuous.py)
├── trackB_discrete/              # Track B: Greedy, ILP, Branch & Bound, DP, and QUBO/Ising
│   ├── README.md
│   ├── src/ (knapsack_solvers.py, qubo_formulations.py, run_trackB.py)
│   └── tests/ (test_discrete.py)
├── trackC_quantum_opt/           # Track C: QAOA, VQE, PQC, Parameter-Shift, SPSA, Barren Plateaus
│   ├── README.md
│   ├── src/ (qaoa_maxcut.py, vqe_pqc.py, barren_plateaus.py, run_trackC.py)
│   └── tests/ (test_quantum_opt.py)
├── trackD_parallel_distributed/  # Track D: Submodular Greedy, Multiprocessing, FedAvg, MGDA/GradNorm
│   ├── README.md
│   ├── src/ (submodular.py, parallel_scaling.py, fedavg.py, multitask_mgda.py, run_trackD.py)
│   └── tests/ (test_parallel_distributed.py)
├── trackE_case_study/            # Track E: Main Case Study (Waste-Collection Capacitated VRP)
│   ├── README.md
│   ├── src/ (cvrp_generator.py, cvrp_solvers.py, run_trackE.py)
│   └── tests/ (test_case_study.py)
├── trackF_compiler/              # Track F: Toy Language Mini-Compiler & Register Allocation
│   ├── README.md
│   ├── src/ (lexer_parser.py, ir_passes.py, reg_alloc.py, run_trackF.py)
│   └── tests/ (test_compiler.py)
├── trackG_xv6/                   # Track G: xv6-riscv MLFQ Scheduler & Copy-on-Write Fork
│   ├── README.md
│   ├── src/ (benchmark_xv6.py, run_trackG.sh, user_benchmarks.c)
│   └── tests/ (test_xv6_patch.py)
├── trackH_dbms/                  # Track H: PostgreSQL 16 TPC-H 0.1 Index Selection (Greedy vs ILP)
│   ├── README.md
│   ├── src/ (tpch_benchmark.py, index_optimizer.py, run_trackH.py)
│   └── tests/ (test_dbms.py)
├── trackI_quantum_algos/         # Track I: Section 5 Quantum Algos, Hand-built Circuits & QML Advantage
│   ├── README.md
│   ├── src/ (quantum_circuits.py, grover_vs_classical.py, qml_classifier.py, run_trackI.py)
│   └── tests/ (test_quantum_algos.py)
├── trackJ_software_eng/          # Track J: Test-Suite Minimization & Prioritization (Requests/Flask)
│   ├── README.md
│   ├── src/ (coverage_collector.py, test_minimizer.py, run_trackJ.py)
│   └── tests/ (test_software_eng.py)
├── results/                      # Output JSON metrics, CSVs, and figures
│   ├── environment.md            # Auto-generated hardware specification
│   └── figures/                  # High-resolution convergence & scaling plots
├── report/                       # Report generation pipeline
│   ├── report.md                 # Primary technical report
│   ├── header.tex                # XeLaTeX header configuration
│   ├── build_pdf.sh              # Pandoc/XeLaTeX/Weasyprint build script
│   ├── fill_report.py            # Strict metric injection script
│   └── verify_pdf.py             # Automatic deliverable validation
├── prompts/                      # Detailed AI prompt logs per track
│   ├── trackA/ ... trackJ/
└── docs/                         # Mandatory disclosure and analysis documentation
    ├── chapter6_checklist.md     # Chapter 6 syllabus mapping
    ├── ai_tools_register.md      # AI tools registry
    ├── failure_log.md            # Documented AI debugging failures and lessons
    ├── tool_comparison.md        # Empirical 2-tool comparison table
    ├── final_questions.md        # Detailed answers to 10 final questions
    ├── demo_script.md            # 5-minute video demonstration walkthrough
    ├── viva_prep.md              # Viva examiner questions, live coding tasks & formula cheat sheet
    └── reproducibility.md        # Deterministic seeds, commands, and runtimes
```

---

## Environment Setup & Requirements

### Host Dependencies (Ubuntu 22.04 LTS / 24.04 LTS or WSL2)
To run the full suite across all tracks, install the required compilers, runtimes, and emulators:

```bash
# Update repositories
sudo apt-get update && sudo apt-get install -y \
    build-essential \
    gcc-riscv64-unknown-elf \
    qemu-system-misc \
    postgresql postgresql-contrib \
    pandoc \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    python3-pip \
    python3-venv \
    git
```

Verify your installation:
```bash
python3 --version              # Expected: >= 3.11.0
gcc --version                  # C compiler
qemu-system-riscv64 --version  # RISC-V QEMU emulator for Track G
psql --version                 # PostgreSQL client for Track H
pandoc --version               # Document converter
xelatex --version              # XeLaTeX PDF engine
```

### Python Virtual Environment Setup

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

Verify your environment using the built-in doctor:
```bash
make doctor
```

---

## Reproducible Execution

All stochastic methods (SGD, Simulated Annealing, VQE, SPSA, FedAvg, CVRP instance generation) use strictly deterministic seeds:
- Global random seed: `42`
- Instance generation seed: `241070040` (student roll number)

### Running All Experiments
To execute all ten tracks, compute empirical metrics, export results to `results/*.json`, and render plots into `results/figures/`:
```bash
make all
```

### Running Individual Tracks
```bash
make trackA   # Continuous optimization (GD, Adam, Newton, Gauss-Newton, Backprop)
make trackB   # Discrete optimization (Knapsack, Max-Cut QUBO/Ising)
make trackC   # Quantum optimization (Simulated QAOA, VQE, Barren Plateaus)
make trackD   # Parallel & distributed (Amdahl, FedAvg, MGDA/GradNorm)
make trackE   # Waste-collection CVRP case study (Greedy, ILP, Heuristics)
make trackF   # Compiler optimization passes & register allocation
make trackG   # xv6 MLFQ & Copy-on-Write benchmarks
make trackH   # PostgreSQL 16 TPC-H 0.1 index selection
make trackI   # Quantum algorithms (Grover, Shor, QFT) & QML Advantage
make trackJ   # Test-suite minimization & prioritization
```

### Automated Unit & Correctness Tests
```bash
make test-all
```

---

## Report & Deliverable Compilation

1. **Inject Measured Values:**
   ```bash
   make report
   ```
   `fill_report.py` replaces every measured metric placeholder with real measured metrics from `results/*.json`. It halts with an error if any placeholder is unresolved.

2. **Compile Technical Report PDF:**
   ```bash
   make pdf
   ```
   Uses Pandoc with XeLaTeX and falls back gracefully to WeasyPrint if needed.

3. **Compile Prompt Logs & Disclosure PDF:**
   ```bash
   make logs-pdf
   ```

4. **Package Submission Deliverables:**
   ```bash
   make submission
   ```
   Produces `OT_Assignment_8_Report.pdf` and `prompts_and_logs.pdf` directly in the project root.

5. **5-Minute Viva Demonstration:**
   ```bash
   make demo
   ```

---

## AI Tools Register

In accordance with Section 8 of the assignment brief, all AI tools utilized during this project are recorded below:

| AI Tool / Assistant | Model Version | Tracks Used | Kind of Work Performed |
| :--- | :--- | :--- | :--- |
| **Antigravity AI Co-author** | `Gemini 3.8 Flash (High)` | Tracks A – J, Docs | Planning, code generation, debugging, testing, technical documentation |
| **Comparative AI Tool (Secondary)** | `Claude 3.5 Sonnet` | Track B & Track F | Comparative benchmarking (correctness, speed, hallucination rate) |

*Detailed prompt transcripts, revisions, and failure logs are preserved in `docs/ai_tools_register.md`, `docs/failure_log.md`, and `prompts/`.*

---

## Chapter 6 Syllabus Checklist

The complete matrix mapping all Chapter 6 techniques to their respective code modules and empirical results is maintained in [docs/chapter6_checklist.md](docs/chapter6_checklist.md).

---

## Publishing to GitHub

To publish this repository to GitHub as a single, verified commit:

### Using GitHub CLI (`gh`):
```bash
git init
git add .
git commit -m "Assignment 8: Complete implementation of Tracks A-J and technical report"
gh repo create Manavaditya-rajesh/OT-Assignment-8 --public --source=. --remote=origin --push
```

### Manual Git Commands:
```bash
git init
git add .
git commit -m "Assignment 8: Complete implementation of Tracks A-J and technical report"
git branch -M main
git remote add origin https://github.com/Manavaditya-rajesh/OT-Assignment-8.git
git push -u origin main
```

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
