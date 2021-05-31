# create ICONCONST file with constant variables
# as well as two extra files containing heights of model full and half levels 
# model_full_levels.nc, model_half_levels.nc

run="nwp0005"
height_file="/work/mh0287/k203123/GIT/icon-aes-dyw2/experiments/dpp0016_atm_vgrid_ml.nc"
grid_file="/work/mh0066/m300752/DYAMOND++/data/weight/griddes_1x1.txt"
weights_file="/work/mh0066/m300752/DYAMOND++/data/weight/weight_dpp0016_1x1.nc"
out_dir="/mnt/lustre02/work/mh1126/m300773/lagranto_input"
lonlatbox='-180,180,-70,70'
half_level_start=17
half_level_end=91

temp_file="${out_dir}/${run}/const.nc"
topo_file="${out_dir}/${run}/topo.nc"
full_levels_file="${out_dir}/${run}/model_full_levels.nc"
half_levels_file="${out_dir}/${run}/model_half_levels.nc"
out_file="${out_dir}/${run}/ICONCONST"

cdo ${CDO_OPTS} sellonlatbox,${lonlatbox} -remap,${grid_file},${weights_file} ${height_file} ${temp_file}
cdo ${CDO_OPTS} --reduce_dim sellevidx,$half_level_end -chname,zghalf,TOPOGRAPHY -selvar,zghalf ${temp_file} ${topo_file}
#cdo ${CDO_OPTS} sellevidx,$level_start/$level_end -chname,zghalf,z_mc,height_2,height -selvar,zghalf ${temp_file} ${full_levels_file}
cdo ${CDO_OPTS} sellevidx,$half_level_start/$half_level_end -chname,zghalf,z_mc,height,height_2 -selvar,zghalf ${temp_file} ${half_levels_file}

cdo merge ${topo_file} ${half_levels_file} ${out_file}

rm ${topo_file} ${half_levels_file} ${temp_file}
