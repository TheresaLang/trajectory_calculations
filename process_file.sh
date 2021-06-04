#!/bin/bash
#SBATCH --job-name=process_file
#SBATCH --output=logs/process_file-%j.out
##SBATCH --error=logs/process_file-%j.err

#SBATCH --account=mh1126             # Charge resources on this project account
#SBATCH --partition=compute,compute2 # partition name
#SBATCH --ntasks=1                   # max. number of tasks to be invoked
#SBATCH --cpus-per-task=36           # number of CPUs per task
#SBATCH --time=01:00:00              # limit on the total run time
#SBATCH --mem=0                      # use all memory on node
##SBATCH --constraint=256G           # only run on fat memory nodes 
##SBATCH --mail-type=FAIL            # Notify user by email in case of job failure

# Set shell options (exit on any error, no unset variables, print commands)
set -o errexit -o nounset -o xtrace
source cdo_config.sh

in_file=$1
out_date=$2
out_dir=$3
grid_file=$4
weights_file=$5
variable=$6
lon_lat_box=$7
timestep=$8

# Iterate through all timesteps in the file
d=${out_date}
while [ $(date -d "${d}" "+%d") == $(date -d "${out_date}" "+%d") ]; do
    # timestep string (needed for cdo seltime)
    s="$(date -d "${d}" +%H:%M:%S)"
    # name of outfile
    date_str=$(date -d "${d}" "+%Y%m%d_%H%M")
    out_file="${out_dir}/${variable}_${date_str}.nc"

    # CDO command
    # selct timestep, change parameter table, select variable, remap, select lon-lat box
    cdo ${CDO_OPTS} \
    sellonlatbox,${lon_lat_box} \
    -remap,${grid_file},${weights_file} \
    -selvar,${variable} \
    -setpartabn,$PARTAB \
    -seltime,${s} \
    ${in_file} ${out_file} \
    || echo 'timestep was not found in file'
    
    # for surface pressure: Add additional dimension of size 1
    if [ ${variable} == 'PS' ]; then
        ncap2 -O -s 'defdim("height",1);PS[$time,$height,$lat,$lon]=PS' ${out_file} ${out_file} 
    fi

    d=$(date -d "${d} ${timestep} minutes" "+%Y%m%d %H%M")  
done

