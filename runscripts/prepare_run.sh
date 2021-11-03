#!bin/bash
set -o errexit -o nounset
source run_config
slurm_options="--partition=${partition} --cpus-per-task=${cpus_per_task} --time=1:00:00"
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
if [[ ${region_def} == 'pw' ]]; then
    sbatch ${slurm_options} ../random_starting_points/startf_from_pw.py ${exp_name} ${lagranto_run_dir} "${first_start_time}" "${last_start_time}" ${start_time_interval} ${num_traj_per_start_time} ${val_start} ${val_end} ${height_start} ${height_end}
elif [[ ${region_def} == 'rh' ]]; then
    sbatch ${slurm_options} ../random_starting_points/startf_from_rh.py ${exp_name} ${lagranto_run_dir} ${input_data_dir} "${first_start_time}" "${last_start_time}" ${start_time_interval} ${num_traj_per_start_time} ${val_start} ${val_end} ${height_start} ${height_end}
fi 
