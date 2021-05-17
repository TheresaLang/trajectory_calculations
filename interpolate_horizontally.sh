#!/bin/bash
#SBATCH --job-name=interpolate_horizontally
#SBATCH --output=logs/interpolate_horizontally-%j.out
##SBATCH --error=interpolate_horizontally-%j.err

#SBATCH --account=mh1126             # Charge resources on this project account
#SBATCH --partition=compute,compute2 # partition name
#SBATCH --ntasks=1                   # max. number of tasks to be invoked
#SBATCH --cpus-per-task=36           # number of CPUs per task
#SBATCH --time=01:00:00              # limit on the total run time
#SBATCH --mem=0                      # use all memory on node
##SBATCH --constraint=256G           # only run on fat memory nodes 
##SBATCH --mail-type=FAIL            # Notify user by email in case of job failure

in_file=$1
out_file=$2
grid_file=$3
weights_file=$4
variable_name_in=$5
variable_name_out=$6
lon_lat_box=$7
seltimestep=$8

temp_file="${out_file}_temp"

if [ -z ${seltimestep} ]; then
    cdo --verbose sellonlatbox,${lon_lat_box} -remap,${grid_file},${weights_file} -chname,${variable_name_in},${variable_name_out} -selvar,${variable_name_in} ${in_file} ${temp_file}
elif [ -n ${seltimestep} ]; then
    cdo --verbose sellonlatbox,${lon_lat_box} -remap,${grid_file},${weights_file} -chname,${variable_name_in},${variable_name_out} -selvar,${variable_name_in} -seltimestep,${seltimestep} ${in_file} ${temp_file}
fi

cdo --verbose splithour ${temp_file} ${out_file}

rm ${temp_file}




