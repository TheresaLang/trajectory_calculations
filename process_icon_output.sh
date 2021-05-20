#!/bin/bash

# general settings
source config.sh

# specific settings
run='nwp0005'
variables=('U' 'V' 'QV' 'P' 'T' 'W' 'PS')
start_date='2020-02-01 00:00'
end_date='2020-02-05 00:00'
timestep=180 # in minutes
#timesteps='00:00:00,03:00:00,06:00:00,09:00:00,12:00:00,15:00:00,18:00:00,21:00:00' 
lon_lat_box='-180,180,-70,70'
grid_file='/work/mh0066/m300752/DYAMOND++/data/weight/griddes_1x1.txt'
weights_file='/work/mh0066/m300752/DYAMOND++/data/weight/weight_dpp0016_1x1.nc'
out_dir='/mnt/lustre02/work/mh1126/m300773/lagranto_input'

job_ids=""
for var in ${variables[@]}; do
    echo ${var}
    read -r -a filelist_in <<< $(bash filelist_in.sh ${run} ${var} "${start_date}" "${end_date}")
    read -r -a filelist_out <<< $(bash filelist_out.sh ${out_dir} ${run} ${var} "${start_date}" "${end_date}")
    echo ${filelist_in[1]}
    for i in ${!filelist_in[@]}; do
        id=$(sbatch process_file.sh ${filelist_in[i]} ${filelist_out[i]} ${grid_file} ${weights_file} ${var} ${lon_lat_box} ${timestep})
	job_ids="${job_ids}:${id:20:28}"
    done
done

# merge files
#sbatch "--dependency=afterok${job_ids}" 
#sbatch ./merge_files.sh ${start_date} ${end_date} ${timesteps} ${variables} "${out_dir}/${run}" 

d=${start_date}
while [ "${d}" != "${end_date}" ]; do
    datestr=$(date -d "${d}" +%Y%m%d_%H)
    sbatch --dependency=afterok${job_ids} merge_files.sh "${out_dir}/${run}/*${datestr}.nc" "${out_dir}/${run}/P${datestr}"
    d=$(date -d "${d} ${timestep} minutes" "+%Y-%m-%d %H:%M")
done

# wenn alle jobs durchgelaufen sind: merge jeweils alle files (=Variablen), die zu einem Zeitschritt gehören
# OMEGA bze. W muss vertical interpoliert werden
