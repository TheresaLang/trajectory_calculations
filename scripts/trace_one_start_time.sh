#!/bin/bash
set -o errexit -o nounset
source run_config
start_time=$1 

ind_core_start=0
ind_core_end=$((${num_cores_per_node}-1))
slurm_options="--partition=${partition} --cpus-per-task=${cpus_per_task} --time=${time_limit} --constraint=${memory}"

for var in "${trace_variables[@]}"; do
    sbatch ${slurm_options} trace_node.sh "${start_time}" ${var}

    stat=$(squeue --start -u $USER | wc -l)
    while ((${stat} > 1)); do
        stat=$(squeue --start -u $USER | wc -l)
        echo "Wait until job is running"
        sleep 5
    done
    # sleep until sub-jobs are running (takes some time because each has to wait until the file trace.config is written and read)
    echo "Wait unitl all jobs are running on node"
    sleep $((180*${num_cores_per_node}))

done    
