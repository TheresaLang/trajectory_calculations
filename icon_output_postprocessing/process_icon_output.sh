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
    # Submit batch job and remember job ID
    #bash process_file.sh ${var}
    id=$(sbatch process_file.sh "${filelist_in}" "${datelist_out}" ${out_dir}/${run} ${grid_file} ${weights_file} ${var} ${lon_lat_box} ${timestep})
    job_ids="${job_ids}:${id:20:28}"
done

### merge files (call merge_files.sh) after status of all previous jobs is "ok"
sbatch --depenency=afterok{job_ids} merge_files.sh
