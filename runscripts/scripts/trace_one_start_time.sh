#!/bin/bash
set -o errexit -o nounset
source run_config
start_time=$1 
start_time_str=$(date -d "${start_time}" "+%Y%m%d_%H%M")
sbatch ${slurm_options} trace_node.sh "${start_time_str}"

stat=$(squeue --start -u $USER | wc -l)
while ((${stat} > 1)); do
    stat=$(squeue --start -n trace_node.sh | wc -l)
    echo "Wait until job is running"
    sleep 5
done
echo "Wait until all jobs are running on node"
sleep $((${#trace_variables[@]}*50))
