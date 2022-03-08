#!/bin/bash
#SBATCH --job-name=postprocessing
#SBATCH --output=logs/process_file-%j.out
##SBATCH --error=logs/process_file-%j.err

#SBATCH --account=mh0287             # Charge resources on this project account
#SBATCH --partition=compute          # partition name
#SBATCH --ntasks=1                   # max. number of tasks to be invoked
#SBATCH --cpus-per-task=36           # number of CPUs per task
#SBATCH --time=04:00:00              # limit on the total run time
#SBATCH --mem=0                      # use all memory on node
##SBATCH --constraint=256G           # only run on fat memory nodes 
##SBATCH --mail-type=FAIL            # Notify user by email in case of job failure

# Set shell options (exit on any error, no unset variables, print commands)
set -o errexit -o nounset -o xtrace
source cdo_config.sh
source config.sh

var=$1
out_dir=${out_dir}/${run}

# get list of files to process for specified variable
read -r -a in_files <<< $(bash filelist_in.sh ${run} ${var} "${start_date}" "${end_date}")
IFS=',' read -r -a out_dates <<< $(bash datelist_out.sh ${run} ${var} "${start_date}" "${end_date}")

echo ${in_files[@]}

for i in ${!in_files[@]}; do
    in_file=${in_files[i]}
    out_date=${out_dates[i]}
    # Iterate through all timesteps in the file
    d=${out_date}
#if [ ${run} == "hsc0036" ]
#then
#    end_date=$(date -d "${out_date} 13 hour" "+%d%H")
#else
#    end_date=$(date -d "${out_date} 12 hour" "+%d%H")
#fi

    #while [ $(date -d "${d}" "+%d%H") -le ${end_date} ]; do
    while [ $(date -d "${d}" "+%d") == $(date -d "${out_date}" "+%d") ]; do
        # timestep string (needed for cdo seltime)
        s="$(date -d "${d}" +%H:%M:%S)"
        # name of outfile
        date_str=$(date -d "${d}" "+%Y%m%d_%H%M")
        out_file="${out_dir}/${var}_${date_str}.nc"
        scaling_command=''
        [[ ${var} =~ ^(QV|QC|QI)$ ]] && scaling_command="-setattribute,${var}@units=mgkg -expr,${var}=${var}*1000000"
        [[ ${var} =~ ^(TQI|TQC|TQR|TQS|TQG)$ ]] && scaling_command="-setattribute,${var}@units=mgm-2 -expr,${var}=${var}*1000000"
        [[ ${var} =~ ^(dQV_T|dQV_M|dQV_D|dQV_TH)$ ]] && scaling_command="-setattribute,${var}@units=fgkg-1s-1 -expr,${var}=${var}*1000000000000000"    
        remap_command=''
        [[ ${remap} == 1 ]] && remap_command="-remap,${grid_file},${weights_file}"
    
        # CDO command
        # selct timestep, change parameter table, select variable, remap, select lon-lat box
        cdo ${CDO_OPTS} -f nc4 \
        sellonlatbox,${lon_lat_box} \
        ${remap_command} \
        ${scaling_command} \
        -selvar,${var} \
        -setpartabn,$PARTAB \
        -seltime,${s} \
        ${in_file} ${out_file} \
        || echo 'timestep was not found in file'
        
        # for surface pressure: Add additional dimension of size 1
        if [ ${var} == 'PS' ]; then
            ncap2 -O -s 'defdim("height",1);PS[$time,$height,$lat,$lon]=PS' ${out_file} ${out_file} 
        fi
        d=$(date -d "${d} ${timestep} minutes" "+%Y%m%d %H%M")
    done
done
