#!/bin/bash
#SBATCH --output=logs/traj-%j.out
##SBATCH --error=logs/traj-%j.err

#SBATCH --account=mh1126             # Charge resources on this project account
#SBATCH --ntasks=1                   # max. number of tasks to be invoked
##SBATCH --mem=0                      # use all memory on node
##SBATCH --mail-type=FAIL            # Notify user by email in case of job failure
set -o errexit -o nounset

source /mnt/lustre02/work/um0878/users/tlang/dev/lagranto/lagranto_config
source run_config

start_time=$1
end_time=$2
ind_core_start=$3
ind_core_end=$4

start_time_str=$(date -d "${start_time}" "+%Y%m%d_%H%M")
end_time_str=$(date -d "${end_time}" "+%Y%m%d_%H%M")
for ((i = ${ind_core_start} ; i <= ${ind_core_end} ; i++)); do
    caltra.icon ${start_time_str} ${end_time_str} "${exp_name}_startf_${start_time_str}_${i}" "${exp_name}_trajectory_${start_time_str}_${i}.4" -j -p > "logs/${exp_name}_caltra_${start_time_str}_${i}.out" & 
    # if several cores are used, sleep until config.caltra file was written and read
    if [[ ! ${ind_core_start} -eq ${ind_core_end}]]; then
        sleep 120
    fi
done

wait
