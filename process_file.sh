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

in_file=$1
out_file=$2
grid_file=$3
weights_file=$4
variable=$5
lon_lat_box=$6
timesteps=$7

temp_file="${out_file}_temp"

cdo $CDO_OPTS \
sellonlatbox,${lon_lat_box} \
-remap,${grid_file},${weights_file} \
-selvar,${variable} \
-setpartabn,$PARTAB \
-seltime,${timesteps} \
${in_file} ${temp_file}
    
cdo --verbose splithour ${temp_file} ${out_file}

rm ${temp_file}




