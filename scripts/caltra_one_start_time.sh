#!/bin/bash

source run_config

start_time=$1
end_time=$2

slurm_options="--partition=${partition} --cpus-per-task=${cpus_per_task} --time=${time_limit} --constraint=${memory}"

sbatch ${slurm_options} caltra_node.sh "${start_time}" "${end_time}" 
# sleep until job is running
stat=$(squeue --start -u $USER | wc -l)
while ((${stat} > 1)); do
    stat=$(squeue --start -u $USER | wc -l)
    echo "Wait until job is running"
    sleep 5
done 
# sleep until sub-jobs are running (takes some time because each has to wait until the file caltra.config is written and read)
echo "Wait unit caltra.config is read"
sleep 15

echo 'all jobs are running'
