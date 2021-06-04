#!/bin/bash
set -o errexit -o nounset
# CDO settings
source cdo_config.sh

# specific settings
source config.sh
variables=( "${p_variables[@]}" "${s_variables[@]}" )
### Create directory for output if it does not exist
[ ! -d "${out_dir}/${run}" ] && mkdir "${out_dir}/${run}"

### Postprocess ICON raw output (call process_file.sh) 
job_ids=""
for var in ${variables[@]}; do
    echo ${var}
    # get list of files to process
    read -r -a filelist_in <<< $(bash filelist_in.sh ${run} ${var} "${start_date}" "${end_date}")
    IFS=',' read -r -a datelist_out <<< $(bash datelist_out.sh ${run} ${var} "${start_date}" "${end_date}")
    for i in ${!filelist_in[@]}; do
	# Submit batch job and remember job ID
        id=$(sbatch process_file.sh ${filelist_in[i]} "${datelist_out[i]}" ${out_dir}/${run} ${grid_file} ${weights_file} ${var} ${lon_lat_box} ${timestep})
	job_ids="${job_ids}:${id:20:28}"
    done
done

### merge files (call merge_files.sh) after status of all previous jobs is "ok"
d=${start_date}
while [ "${d}" != "${end_date}" ]; do
    datestr=$(date -d "${d}" +%Y%m%d_%H%M)
    p_file_str=""
    s_file_str=""
    for var in ${p_variables[@]}; do
        p_file_str="${p_file_str}${out_dir}/${run}/${var}_${datestr}.nc "
    done
    for var in ${s_variables[@]}; do
        s_file_str="${s_file_str}${out_dir}/${run}/${var}_${datestr}.nc "
    done
    sbatch --dependency=afterok${job_ids} merge_files.sh "${p_file_str}" "${out_dir}/${run}/P${datestr}"
    sbatch --dependency=afterok${job_ids} merge_files.sh "${s_file_str}" "${out_dir}/${run}/S${datestr}"
    d=$(date -d "${d} ${timestep} minutes" "+%Y-%m-%d %H:%M")
done

