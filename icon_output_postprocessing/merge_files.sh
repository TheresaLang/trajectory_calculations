#!/bin/bash
#SBATCH --job-name=merge_files
#SBATCH --output=logs/merge_files-%j.out
##SBATCH --error=logs/merge_files-%j.err

#SBATCH --account=mh0287             # Charge resources on this project account
#SBATCH --partition=compute          # partition name
#SBATCH --ntasks=1                   # max. number of tasks to be invoked
#SBATCH --cpus-per-task=36           # number of CPUs per task
#SBATCH --time=08:00:00              # limit on the total run time
#SBATCH --mem=0                      # use all memory on node
##SBATCH --constraint=256G           # only run on fat memory nodes 
##SBATCH --mail-type=FAIL            # Notify user by email in case of job failure

set -o errexit -o nounset
module load python3
source config.sh
source cdo_config.sh

d=${start_date}
while [ "${d}" != "${end_date}" ]; do
    datestr=$(date -d "${d}" +%Y%m%d_%H%M)
    p_file_str=""
    s_file_str=""
    for var in ${p_variables[@]}; do
        p_file_str="${p_file_str}${out_dir}/${run}/lagranto_input/${var}_${datestr}.nc "
    done
    for var in ${s_variables[@]}; do
        s_file_str="${s_file_str}${out_dir}/${run}/lagranto_input/${var}_${datestr}.nc "
    done
    cdo ${CDO_OPTS} merge "${p_file_str}" "${out_dir}/${run}/lagranto_input/P${datestr}"
    cdo ${CDO_OPTS} merge "${s_file_str}" "${out_dir}/${run}/lagranto_input/S${datestr}"
    rm ${p_file_str}
    rm ${s_file_str}
    d=$(date -d "${d} ${timestep} minutes" "+%Y-%m-%d %H:%M")
done

