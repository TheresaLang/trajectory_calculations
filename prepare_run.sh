#!bin/bash
set -o errexit -o nounset
source run_config
# create run directory
[ ! -d ${lagranto_run_dir} ] && mkdir ${lagranto_run_dir}
[ ! -d ${lagranto_run_dir}/logs ] && mkdir ${lagranto_run_dir}/logs
# link input data
echo 'link input files'
bash link_input_files.sh
# link runscripts
echo 'link scripts'
bash link_runscripts.sh
# create startf files
echo 'create startf files' 
num_batches=$((${num_nodes_per_start_time}*${num_cores_per_node}))
if [[ region_def == 'pw' ]]; then
    python ../random_starting_points/startf_from_pw.py ${exp_name} ${lagranto_run_dir} "${first_start_time}" "${last_start_time}" ${start_time_interval} ${num_traj_per_start_time} ${num_batches} ${val_start} ${val_end} ${height_start} ${height_end}
elif [[ region_def == 'rh' ]]; then
    python ../random_starting_points/startf_from_rh.py ${exp_name} ${lagranto_run_dir} "${first_start_time}" "${last_start_time}" ${start_time_interval} ${num_traj_per_start_time} ${num_batches} ${val_start} ${val_end} ${height_start} ${height_end} 
