#!/bin/bash
set -o errexit -o nounset
source run_config
start_time=$1 

slurm_options="--partition=${partition} --cpus-per-task=${cpus_per_task} --time=${time_limit} --constraint=${memory}"

sbatch ${slurm_options} trace_node.sh "${start_time}"

stat=$(squeue --start -u $USER | wc -l)
while ((${stat} > 1)); do
    stat=$(squeue --start -u $USER | wc -l)
    echo "Wait until job is running"
    sleep 5
done
