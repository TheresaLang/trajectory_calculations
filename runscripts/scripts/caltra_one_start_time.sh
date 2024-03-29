#!/bin/bash

source run_config

start_time=$1
end_time=$2
start_time_str=$(date -d "${start_time}" "+%Y%m%d_%H%M")
end_time_str=$(date -d "${end_time}" "+%Y%m%d_%H%M")

sbatch ${slurm_options} caltra_node.sh "${start_time_str}" "${end_time_str}" 
# sleep until job is running
stat=$(squeue --start -n caltra | wc -l)
while ((${stat} > 1)); do
    stat=$(squeue --start -n caltra | wc -l)
    echo "Wait until job is running"
    sleep 5
done 
# sleep until sub-jobs are running (takes some time because each has to wait until the file caltra.config is written and read)
echo "Wait unit caltra.config is read"
sleep 15

echo 'all jobs are running'
