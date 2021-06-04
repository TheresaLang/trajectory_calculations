#!/bin/bash
source config.sh

d=${start_date}
while [ "${d}" != "${end_date}" ]; do
    datestr=$(date -d "${d}" +%Y%m%d_%H%M)
    ln -s "${out_dir}/${run}/P${datestr}" "${run_dir}"
    ln -s "${out_dir}/${run}/S${datestr}" "${run_dir}"
    d=$(date -d "${d} ${timestep} minutes" "+%Y-%m-%d %H:%M")
done

ln -s "${out_dir}/${run}/ICONCONST" "${run_dir}"




