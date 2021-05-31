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
timestep=$7

temp_file="${out_file}_temp"

### Opitons for CDO command
# Create string for CDO command seltime
timestep_str=''
d='1970-01-01 00:00:00'
while [ $(date -d "${d}" "+%d") == '01' ]; do
    s="$(date -d "${d}" +%H:%M:%S)"
    timestep_str="${timestep_str},${s}" 
    d=$(date -d "${d} ${timestep} minutes" "+%Y-%m-%d %H:%M:%S")  
done

# Create CDO command sellev
sellev='' # empty command for all variables except vertical velocity W
# For W the uppermost and lowermost levels are removed
if [ ${variable} == 'W' ]; then
    sellev="-sellevidx,2/74/1"
fi

### CDO command
cdo ${CDO_OPTS} \
# select latitude-longitude box
sellonlatbox,${lon_lat_box} \
# regrid to latitude-longitude grid
-remap,${grid_file},${weights_file} \
# select levels (only for vertical velocity)
${sellev} \
# select variabble
-selvar,${variable} \
# rename variables
-setpartabn,$PARTAB \
# select timesteps
-seltime${timestep_str} \
${in_file} ${temp_file}

### Additional height dimension for PS
if [ ${variable} == 'PS' ]; then
    ncap2 -O -s 'defdim("height",1);PS[$time,$height,$lat,$lon]=PS' ${temp_file} ${temp_file} 
fi

### Split file into one file for each time step  
cdo ${CDO_OPTS} splithour ${temp_file} ${out_file}

rm ${temp_file}




