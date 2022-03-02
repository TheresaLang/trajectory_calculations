start_date="2021-07-23 01:00"
end_date="2021-07-23 02:00"
in_dir="/mnt/lustre02/work/mh1126/m300773/lagranto_input/hsc0036"
out_dir="/mnt/lustre02/work/mh1126/m300773/lagranto_input/hsc0036/interp"
vgrid_file="${in_dir}/vgrid_interp.nc"
d=${start_date}
while [ "${d}" != "${end_date}" ]; do
    datestr=$(date -d "${d}" "+%Y%m%d_%H%M")
    p_file="${in_dir}/P${datestr}"
    s_file="${in_dir}/S${datestr}"
    p_file_out="${out_dir}/P${datestr}"
    s_file_out="${out_dir}/S${datestr}"
    sbatch vertical_interp_file.py ${vgrid_file} ${p_file} ${s_file} ${p_file_out} ${s_file_out}
    d=$(date -d "${d} 1 hours" "+%Y-%m-%d %H:%M")
done
