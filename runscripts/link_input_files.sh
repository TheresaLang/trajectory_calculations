#!/bin/bash
set -o nounset
source run_config

d=${input_data_start_time}
stop_time=$(date -d "${input_data_end_time} ${input_timestep} minutes" "+%Y-%m-%d %H:%M")
while [ "${d}" != "${stop_time}" ]; do
    datestr=$(date -d "${d}" +%Y%m%d_%H%M)
    if [[ ${input_timestep} -lt 60 ]]; then
    	datestr_out=$(date -d "${d}" +%Y%m%d_%H%M)
    else
    	datestr_out=$(date -d "${d}" +%Y%m%d_%H)
    fi
    ln -s "${input_data_dir}/P${datestr}" "${lagranto_run_dir}/P${datestr_out}"
    ln -s "${input_data_dir}/S${datestr}" "${lagranto_run_dir}/S${datestr_out}"
    d=$(date -d "${d} ${input_timestep} minutes" "+%Y-%m-%d %H:%M")
done

ln -s "${input_data_dir}/ICONCONST" "${lagranto_run_dir}"




