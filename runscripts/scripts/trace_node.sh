#!/bin/bash
#SBATCH --output=logs/trace-%j.out
#SBATCH --ntasks=1                   # max. number of tasks to be invoked
#SBATCH --mem=0                      # use all memory on node
#SBATCH --exclusive                  # use whole node
set -o errexit -o nounset
source /work/mh1126/m300773/dev/lagranto/lagranto_config
source run_config

start_time_str=$1
echo ${start_time}
#start_time_str=$(date -d "${start_time}" "+%Y%m%d_%H%M")
for var in "${trace_variables[@]}"; do
    tracevar_file="tracevars_${var}"
    trajectory_file="${exp_name}_trajectory_${start_time_str}.4"
    outfile="${exp_name}_${var}_traced_${start_time_str}.4"
    trace.icon ${trajectory_file} ${outfile} -v ${tracevar_file} > "logs/${exp_name}_trace_${var}_${start_time_str}.out" & 
    # sleep until config.trace file was written and read
    sleep 45    
done

wait

