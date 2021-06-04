#!/bin/bash
source config.sh

d=${start_date}
while [ "${d}" != "${end_date}" ]; do
    datestr=$(date -d "${d}" +%Y%m%d_%H)
    ln -s "${source_dir}/P${datestr}" "${target_dir}"
    d=$(date -d "${d} ${timestep} minutes" "+%Y-%m-%d %H:%M")
done

ln -s "${source_dir}/ICONCONST" "${target_dir}"




