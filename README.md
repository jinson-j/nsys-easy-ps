# nsys-easy-ps

A simple wrapper script for NVIDIA Nsight Systems (`nsys`) to simplify profiling.

> This is a PowerShell translation of the original Bash script by Mark Harris, found at [harrism/nsys_easy](https://github.com/harrism/nsys_easy).

This script is a wrapper around the `nsys` command to simplify the profiling process. It allows you to specify the trace, sample, and context switch options, as well as the output and report names.

The script runs the `nsys profile` command and then the `nsys stats` command.

By default, the script only traces CUDA API calls (`--trace=cuda`) and runs the `cuda_gpu_sum` report, which combines Kernel and CUDA memory copy statistics. The goal is to provide a user experience similar to the old `nvprof` command, but with the modern flexibility of Nsight Systems.

## Prerequisites

 - [NVIDIA NSight Systems](https://developer.nvidia.com/nsight-systems)
 - Bash or other shell that supports `getopts`

For full `nsys` command line options, see the [NSight Systems User Guide](https://docs.nvidia.com/nsight-systems/UserGuide/index.html).

## Installation

1. Place the `nsys_easy.ps1` script in a directory listed in your `$env:PATH`.
2. You may need to adjust your [Execution Policy](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy) to run local scripts.

```PowerShell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Usage

```powershell
.\nsys_easy.ps1 [-t trace] [-s sample] [-c ctxsw] [-o output] [-r report] command [args...]
```

```powershell
.\nsys_easy.ps1 -t cuda,osrt -o my_profile -r cuda_gpu_kernel_sum .\my_program.exe
```

This will:
1. Run `nsys profile` and create `my_profile.nsys-rep`.    
2. Run `nsys stats` and create `my_profile.sqlite`.
