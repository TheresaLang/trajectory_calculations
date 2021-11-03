#!/bin/bash
source config.sh

d=${start_date}
while [ "${d}" != "${end_date}" ]; do
    datestr=$(date -d "${d}" +%Y%m%d_%H%M)
    if [[ ${timestep} -lt 60 ]]; then
    	datestr_out=$(date -d "${d}" +%Y%m%d_%H%M)
    else
    	datestr_out=$(date -d "${d}" +%Y%m%d_%H)
    fi
    ln -s "${out_dir}/${run}/P${datestr}" "${run_dir}/P${datestr_out}"
    ln -s "${out_dir}/${run}/S${datestr}" "${run_dir}/S${datestr_out}"
    d=$(date -d "${d} ${timestep} minutes" "+%Y-%m-%d %H:%M")
done

ln -s "${out_dir}/${run}/ICONCONST" "${run_dir}"




