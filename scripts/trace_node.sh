#!/bin/bash
#SBATCH --output=logs/trace-%j.out
##SBATCH --error=logs/trace-%j.err

#SBATCH --account=mh1126             # Charge resources on this project account
#SBATCH --ntasks=1                   # max. number of tasks to be invoked
##SBATCH --mem=0                      # use all memory on node
##SBATCH --mail-type=FAIL            # Notify user by email in case of job failure
set -o errexit -o nounset
source /mnt/lustre02/work/um0878/users/tlang/dev/lagranto/lagranto_config
source run_config

start_time=$1

start_time_str=$(date -d "${start_time}" "+%Y%m%d_%H%M")
for var in "${trace_variables[@]}"; do
    tracevar_file="tracevars_${var}"
    for (( i = 0 ; i < ${num_cores_per_node} ; i++ )); do
        trajectory_file="${exp_name}_trajectory_${start_time_str}_${i}.4"
        outfile="${exp_name}_${var}_traced_${start_time_str}_${i}.4"
        trace.icon ${trajectory_file} ${outfile} -v ${tracevar_file} > "logs/${exp_name}_trace_${var}_${start_time_str}_${i}.out" & 
        # sleep until config.trace file was written and read
        sleep 120    
    done
done

wait

