#!/bin/bash

run="dpp0029"
variables=("PS")
start_date="2020-02-01"
end_date="2020-02-05"
lon_lat_box="-180,180,-70,70"
grid_file="/work/mh0066/m300752/DYAMOND++/data/weight/griddes_1x1.txt"
weights_file="/work/mh0066/m300752/DYAMOND++/data/weight/weight_dpp0016_1x1.nc"
out_dir="/mnt/lustre02/work/mh1126/m300773/lagranto_input"

for var in ${variables[@]}; do
    echo ${var}
    var_name_in=$(bash variable_name.sh ${run} ${var})
    read -r -a filelist_in <<< $(bash filelist_in.sh ${run} ${var} ${start_date} ${end_date})
    read -r -a filelist_out <<< $(bash filelist_out.sh ${out_dir} ${run} ${var} ${start_date} ${end_date})
    echo ${filelist_in[1]}
    for i in ${!filelist_in[@]}; do
        sbatch interpolate_horizontally.sh ${filelist_in[i]} ${filelist_out[i]} ${grid_file} ${weights_file} ${var_name_in} ${var} ${lon_lat_box}
    done
done    

# wenn alle jobs durchgelaufen sind: merge jeweils alle files (=Variablen), die zu einem Zeitschritt gehören
# OMEGA muss vertical interpoliert werden