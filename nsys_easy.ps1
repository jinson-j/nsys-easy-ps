# This script is a translated clone of https://github.com/harrism/nsys_easy

# This script is a wrapper around the nsys command to simplify the profiling process.
# It allows you to specify the trace, sample, and context switch options, as well as the output and report names.
# The script will run the nsys profile command and then the nsys stats command.
# Usage: .\nsys_easy.ps1 [-t trace] [-s sample] [-c ctxsw] [-o output] [-r report] command
# Example: .\nsys_easy.ps1 -t cuda,osrt -s none -c none -o nsys_easy -r cuda_gpu_kernel_sum .\my_program.exe
# The above command will profile the my_program.exe executable with the specified options and output files.
#
# By default the script only traces CUDA API calls, but you can specify additional options to trace other events.
# The script runs the cuda_gpu_sum report by default, which combines Kernel and CUDA memory copy statistics.
# The goal is for the script to act similar to the nvprof command, but with the added flexibility of the NVIDIA Nsight Systems tool.

# Default values
$trace = "cuda"
$sample = "none"
$ctxsw = "none"
$output = "nsys_easy"
$report = "cuda_gpu_sum"

# Usage function
function Show-Usage {
    Write-Host "Usage: .\nsys_easy.ps1 [-t trace] [-s sample] [-c ctxsw] [-o output] [-r report] command [args...]"
    Write-Host "  -t trace   : Set the trace option (default: cuda)"
    Write-Host "  -s sample  : Set the sample option (default: none)"
    Write-Host "  -c ctxsw   : Set the context switch option (default: none)"
    Write-Host "  -o output  : Set the output file name (default: nsys_easy)"
    Write-Host "  -r report  : Set the report name (default: cuda_gpu_sum)"
    exit 1
}

# Parse command line options
$i = 0
$command = @()
while ($i -lt $args.Count) {
    switch ($args[$i]) {
        "-t" {
            $i++
            if ($i -lt $args.Count) {
                $trace = $args[$i]
            }
        }
        "-s" {
            $i++
            if ($i -lt $args.Count) {
                $sample = $args[$i]
            }
        }
        "-c" {
            $i++
            if ($i -lt $args.Count) {
                $ctxsw = $args[$i]
            }
        }
        "-o" {
            $i++
            if ($i -lt $args.Count) {
                $output = $args[$i]
            }
        }
        "-r" {
            $i++
            if ($i -lt $args.Count) {
                $report = $args[$i]
            }
        }
        default {
            # Everything else is the command
            $command += $args[$i..($args.Count-1)]
            break
        }
    }
    $i++
}

# Check if command is provided
if ($command.Count -eq 0) {
    Show-Usage
}

# Run the nsys profile command
& nsys profile "--trace=$trace" "--sample=$sample" "--cpuctxsw=$ctxsw" --force-overwrite=true -o $output @command

# Run the nsys stats command
& nsys stats --force-export=true -r $report "$output.nsys-rep"
