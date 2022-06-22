#!/bin/bash
#SBATCH --job-name=caltra
#SBATCH --output=logs/traj-%j.out
#SBATCH --ntasks=1                   # max. number of tasks to be invoked
##SBATCH --mem=0                      # use all memory on node
set -o errexit -o nounset

source /work/mh1126/m300773/dev/lagranto/lagranto_config
source run_config

start_time=$1
end_time=$2

start_time_str=$(date -d "${start_time}" "+%Y%m%d_%H%M")
end_time_str=$(date -d "${end_time}" "+%Y%m%d_%H%M")
caltra.icon ${start_time_str} ${end_time_str} "${exp_name}_startf_${start_time_str}" "${exp_name}_trajectory_${start_time_str}.4" -j -p > "logs/${exp_name}_caltra_${start_time_str}.out"
