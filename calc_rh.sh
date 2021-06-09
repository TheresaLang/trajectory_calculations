#!/bin/bash
#SBATCH --job-name=rh_calculation
#SBATCH --output=logs/rh_calculation-%j.out
##SBATCH --error=logs/rh_calculation-%j.err

#SBATCH --account=mh1126       # Charge resources on this project account
#SBATCH --partition=compute,compute2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=36     # Specify number of CPUs per task
#SBATCH --time=08:00:00        # Set a limit on the total run time
#SBATCH --mem=0                # use all memory on node
#SBATCH --constraint=256G      # only run on fat memory nodes (needed for NICAM)
#SBATCH --monitoring=meminfo=10,cpu=5,lustre=5
##SBATCH --mail-type=FAIL      # Notify user by email in case of job failure
source config.sh
z_file="${out_dir}/${run}/ICONCONST"

d=${start_date}
while [ "${d}" != "${end_date}" ]; do
    datestr=$(date -d "${d}" +%Y%m%d_%H%M)
    p_file="${out_dir}/${run}/P${datestr}"
    s_file="${out_dir}/${run}/S${datestr}"
    rh_file="${out_dir}/${run}/RH_${datestr}.nc"
    python calc_rh_file.py ${p_file} ${s_file} ${z_file} ${rh_file}
    d=$(date -d "${d} ${timestep} minutes" "+%Y-%m-%d %H:%M")
done
