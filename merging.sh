et -o errexit -o nounset
# CDO settings
source cdo_config.sh

# specific settings
source config.sh
variables=( "${p_variables[@]}" "${s_variables[@]}" )
### Create directory for output if it does not exist
[ ! -d "${out_dir}/${run}" ] && mkdir "${out_dir}/${run}"


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
    sbatch merge_files.sh "${p_file_str}" "${out_dir}/${run}/P${datestr}"
    sbatch merge_files.sh "${s_file_str}" "${out_dir}/${run}/S${datestr}"
    d=$(date -d "${d} ${timestep} minutes" "+%Y-%m-%d %H:%M")
done

