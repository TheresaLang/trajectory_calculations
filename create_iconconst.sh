# create ICONCONST file with constant variables
# as well as two extra files containing heights of model full and half levels 
# model_full_levels.nc, model_half_levels.nc

run="nwp0005"
height_file="/work/mh0287/k203123/GIT/icon-aes-dyw2/experiments/dpp0016_atm_vgrid_ml.nc"
grid_file="/work/mh0066/m300752/DYAMOND++/data/weight/griddes_1x1.txt"
weights_file="/work/mh0066/m300752/DYAMOND++/data/weight/weight_dpp0016_1x1.nc"
out_dir="/mnt/lustre02/work/mh1126/m300773/lagranto_input"
level_start=16
level_end=90

level_surf=$((level_end+1))
half_level_start=$((level_start+1))
half_level_end=$((level_end+1))

temp_file="${out_dir}/${run}/const.nc"
topo_file="${out_dir}/${run}/topo.nc"
full_levels_file="${out_dir}/${run}/model_full_levels.nc"
half_levels_file="${out_dir}/${run}/model_half_levels.nc"
out_file="${out_dir}/${run}/ICONCONST"

cdo remap,${grid_file},${weights_file} ${height_file} ${temp_file}
cdo --reduce_dim sellevidx,$level_surf -chname,zghalf,TOPOGRAPHY -selvar,zghalf ${temp_file} ${topo_file}
cdo sellevidx,$level_start/$level_end -chname,zg,z_mc -selvar,zg ${temp_file} ${full_levels_file}
cdo sellevidx,$half_level_start/$half_level_end -chname,zghalf,z_mc -selvar,zghalf ${temp_file} ${half_levels_file}

cdo merge ${topo_file} ${full_levels_file} ${out_file}

rm ${topo_file} ${temp_file}