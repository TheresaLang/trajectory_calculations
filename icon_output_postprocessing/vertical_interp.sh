start_date="2021-06-27 01:00"
end_date="2021-06-30 00:00"
in_dir="/mnt/lustre02/work/mh1126/m300773/lagranto_input/hsc0036/not_interp"
out_dir="/mnt/lustre02/work/mh1126/m300773/lagranto_input/hsc0036"
vgrid_file="${in_dir}/vgrid_interp.nc"
d=${start_date}
while [ "${d}" != "${end_date}" ]; do
    datestr=$(date -d "${d} 1 hour" "+%Y%m%d_%H%M")
    p_file="${in_dir}/P${datestr}"
    s_file="${in_dir}/S${datestr}"
    p_file_out="${out_dir}/P${datestr}"
    s_file_out="${out_dir}/S${datestr}"
    sbatch vertical_interp.py ${vgrid_file} ${p_file} ${s_file} ${p_file_out} ${s_file_out}
    d=$(date -d "${d} 1 hours" "+%Y-%m-%d %H:%M")
done
