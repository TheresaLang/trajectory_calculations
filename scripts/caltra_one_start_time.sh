#!/bin/bash

source run_config

start_time=$1
end_time=$2

ind_core_start=0
ind_core_end=$((${num_cores_per_node}-1))
slurm_options="--partition=${partition} --cpus-per-task=${cpus_per_task} --time=${time_limit} --constraint=${memory}"

for ((i = 0 ; i < "${num_nodes_per_start_time}" ; i++)); do
    echo $i
    sbatch ${slurm_options} caltra_node.sh "${start_time}" "${end_time}" ${ind_core_start} ${ind_core_end}
    ind_core_start=$((ind_core_start+${num_cores_per_node}))
    ind_core_end=$((ind_core_end+${num_cores_per_node}))
    # sleep until job is running
    stat=$(squeue --start -u $USER | wc -l)
    while ((${stat} > 1)); do
        stat=$(squeue --start -u $USER | wc -l)
        echo "Wait until job is running"
        sleep 5
    done 
    # sleep until sub-jobs are running (takes some time because each has to wait until the file caltra.config is written and read)
    echo "Wait unitl all jobs are running on node"
    sleep $((150*${num_cores_per_node}))
done
echo 'all jobs are running'
