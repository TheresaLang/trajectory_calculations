source config.sh
z_file="${out_dir}/${run}/ICONCONST"

d=${start_date}
while [ "${d}" != "${end_date}" ]; do
    datestr=$(date -d "${d}" +%Y%m%d_%H%M)
    p_file="${out_dir}/${run}/P${datestr}"
    s_file="${out_dir}/${run}/S${datestr}"
    rh_file="${out_dir}/${run}/RH_${datestr}.nc"
    sbatch calc_rh_file.py ${p_file} ${s_file} ${z_file} ${rh_file}
    d=$(date -d "${d} ${timestep} minutes" "+%Y-%m-%d %H:%M")
done
