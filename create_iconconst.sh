# create ICONCONST file with constant variables
# as well as two extra files containing heights of model full and half levels 
# model_full_levels.nc, model_half_levels.nc
source config.sh
half_level_start=14
half_level_end=91

temp_file="${out_dir}/${run}/const.nc"
topo_file="${out_dir}/${run}/topo.nc"
full_levels_file="${out_dir}/${run}/model_full_levels.nc"
half_levels_file="${out_dir}/${run}/model_half_levels.nc"
out_file="${out_dir}/${run}/ICONCONST"

cdo ${CDO_OPTS} sellonlatbox,${lon_lat_box} -remap,${grid_file},${weights_file} ${height_file} ${temp_file}
cdo ${CDO_OPTS} --reduce_dim sellevidx,$half_level_end -chname,zghalf,TOPOGRAPHY -selvar,zghalf ${temp_file} ${topo_file}
#cdo ${CDO_OPTS} sellevidx,$level_start/$level_end -chname,zghalf,z_mc,height_2,height -selvar,zghalf ${temp_file} ${full_levels_file}
cdo ${CDO_OPTS} sellevidx,$half_level_start/$half_level_end -chname,zghalf,z_mc,height,height_2 -selvar,zghalf ${temp_file} ${half_levels_file}

cdo merge ${topo_file} ${half_levels_file} ${out_file}

rm ${topo_file} ${half_levels_file} ${temp_file}
