#!/bin/bash
#SBATCH --job-name=merge_files
#SBATCH --output=logs/merge_files-%j.out
##SBATCH --error=logs/merge_files-%j.err

#SBATCH --account=mh1126             # Charge resources on this project account
#SBATCH --partition=compute,compute2 # partition name
#SBATCH --ntasks=1                   # max. number of tasks to be invoked
#SBATCH --cpus-per-task=36           # number of CPUs per task
#SBATCH --time=01:00:00              # limit on the total run time
#SBATCH --mem=0                      # use all memory on node
##SBATCH --constraint=256G           # only run on fat memory nodes 
##SBATCH --mail-type=FAIL            # Notify user by email in case of job failure

infiles=$1
outfile=$2

echo ${infiles}
echo ${outfile}

cdo ${CDO_OPTS} merge ${infiles} ${outfile}
rm ${infiles}
