#!/bin/bash

source_dir="/mnt/lustre02/work/mh1126/m300773/lagranto_input/nwp0005"
target_dir="/mnt/lustre02/work/um0878/users/tlang/work/rh_sensitivity/lagranto/runscripts/first_test"

start_date='2020-02-01 03:00'
end_date='2020-02-05 00:00'
timestep=180 #in minutes

d=${start_date}
while [ "${d}" != "${end_date}" ]; do
    datestr=$(date -d "${d}" +%Y%m%d_%H)
    ln -s "${source_dir}/P${datestr}" "${target_dir}"
    d=$(date -d "${d} ${timestep} minutes" "+%Y-%m-%d %H:%M")
done

ln -s "${source_dir}/ICONCONST" "${target_dir}"




