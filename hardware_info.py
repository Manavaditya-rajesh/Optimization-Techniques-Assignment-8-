#!/usr/bin/env python3
"""
hardware_info.py
Records host hardware specs and tool versions into results/environment.md.
Follows strict project rules: No timestamps/dates included.
"""

import os
import platform
import shutil
import subprocess
import sys

def get_cmd_output(cmd):
    """Run a command and return stdout string, or 'Not Found / Not Installed'."""
    try:
        res = subprocess.run(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            shell=isinstance(cmd, str),
            timeout=5
        )
        if res.returncode == 0:
            lines = res.stdout.strip().splitlines()
            return lines[0].strip() if lines else "Installed (no output)"
        return "Not available (exit code {})".format(res.returncode)
    except Exception as e:
        return "Not installed / Not available"

def get_cpu_info():
    """Detect CPU model and core counts."""
    cpu_name = platform.processor() or "Unknown CPU"
    # Try reading /proc/cpuinfo on Linux
    if os.path.exists("/proc/cpuinfo"):
        try:
            with open("/proc/cpuinfo", "r") as f:
                for line in f:
                    if "model name" in line:
                        cpu_name = line.split(":", 1)[1].strip()
                        break
        except Exception:
            pass
    # Try Windows registry/wmic if generic
    if platform.system() == "Windows":
        try:
            res = subprocess.run(
                ["wmic", "cpu", "get", "name"],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                timeout=5
            )
            if res.returncode == 0:
                lines = [l.strip() for l in res.stdout.splitlines() if l.strip() and "Name" not in l]
                if lines:
                    cpu_name = lines[0]
        except Exception:
            pass

    logical_cores = os.cpu_count() or 1
    physical_cores = logical_cores
    try:
        import psutil
        physical_cores = psutil.cpu_count(logical=False) or logical_cores
    except ImportError:
        pass

    return cpu_name, physical_cores, logical_cores

def get_memory_info():
    """Detect RAM capacity."""
    total_gb = "Unknown"
    avail_gb = "Unknown"
    try:
        import psutil
        mem = psutil.virtual_memory()
        total_gb = f"{mem.total / (1024**3):.2f} GB"
        avail_gb = f"{mem.available / (1024**3):.2f} GB"
    except ImportError:
        if os.path.exists("/proc/meminfo"):
            try:
                with open("/proc/meminfo", "r") as f:
                    for line in f:
                        if line.startswith("MemTotal:"):
                            kb = int(line.split()[1])
                            total_gb = f"{kb / (1024**2):.2f} GB"
                        elif line.startswith("MemAvailable:"):
                            kb = int(line.split()[1])
                            avail_gb = f"{kb / (1024**2):.2f} GB"
            except Exception:
                pass
    return total_gb, avail_gb

def get_gpu_info():
    """Detect GPU info via nvidia-smi."""
    gpu = get_cmd_output("nvidia-smi --query-gpu=name,memory.total --format=csv,noheader")
    if "Not" in gpu or "exit" in gpu:
        return "None detected / CPU-only execution"
    return gpu

def get_python_package_version(pkg_name):
    """Retrieve version of an installed Python package."""
    try:
        mod = __import__(pkg_name)
        return getattr(mod, "__version__", "Installed (unknown version)")
    except ImportError:
        return "Not installed in active environment"

def main():
    os.makedirs("results", exist_ok=True)
    out_file = os.path.join("results", "environment.md")

    cpu_name, phys_cores, log_cores = get_cpu_info()
    ram_total, ram_avail = get_memory_info()
    gpu_info = get_gpu_info()

    # Tool checks
    tools = [
        ("Python Interpreter", sys.version.split()[0]),
        ("GCC Compiler", get_cmd_output(["gcc", "--version"])),
        ("RISC-V QEMU", get_cmd_output(["qemu-system-riscv64", "--version"])),
        ("PostgreSQL Client (psql)", get_cmd_output(["psql", "--version"])),
        ("Pandoc", get_cmd_output(["pandoc", "--version"])),
        ("XeLaTeX Engine", get_cmd_output(["xelatex", "--version"])),
        ("WeasyPrint Fallback", get_cmd_output(["weasyprint", "--version"])),
        ("Git Version Control", get_cmd_output(["git", "--version"])),
    ]

    libraries = [
        ("NumPy", get_python_package_version("numpy")),
        ("SciPy", get_python_package_version("scipy")),
        ("Matplotlib", get_python_package_version("matplotlib")),
        ("Pandas", get_python_package_version("pandas")),
        ("PuLP", get_python_package_version("pulp")),
        ("NetworkX", get_python_package_version("networkx")),
        ("PyTorch", get_python_package_version("torch")),
        ("Qiskit", get_python_package_version("qiskit")),
        ("PennyLane", get_python_package_version("pennylane")),
        ("PyTest", get_python_package_version("pytest")),
    ]

    lines = []
    lines.append("# Hardware and Software Environment Specification")
    lines.append("")
    lines.append("## 1. Host Hardware")
    lines.append("")
    lines.append("| Component | Specification |")
    lines.append("| :--- | :--- |")
    lines.append(f"| **Operating System** | {platform.system()} {platform.release()} ({platform.machine()}) |")
    lines.append(f"| **Kernel Version** | {platform.version()} |")
    lines.append(f"| **CPU Model** | {cpu_name} |")
    lines.append(f"| **Physical Cores** | {phys_cores} |")
    lines.append(f"| **Logical Threads** | {log_cores} |")
    lines.append(f"| **Total System RAM** | {ram_total} |")
    lines.append(f"| **Available System RAM** | {ram_avail} |")
    lines.append(f"| **GPU Device** | {gpu_info} |")
    lines.append("")
    lines.append("## 2. System Toolchains")
    lines.append("")
    lines.append("| Tool / Utility | Version / Status |")
    lines.append("| :--- | :--- |")
    for name, ver in tools:
        lines.append(f"| **{name}** | {ver} |")
    lines.append("")
    lines.append("## 3. Python Optimization & Simulation Libraries")
    lines.append("")
    lines.append("| Library | Version / Status |")
    lines.append("| :--- | :--- |")
    for name, ver in libraries:
        lines.append(f"| **{name}** | {ver} |")
    lines.append("")

    with open(out_file, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

    print(f"[+] Successfully generated {out_file}")

if __name__ == "__main__":
    main()
