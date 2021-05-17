#!/bin/bash

run=$1
var=$2
start_date=$3
end_date=$4

filelist=()
declare -A var2file

case ${run} in

    "dpp0029")
        directory="/mnt/lustre01/work/mh0287/k203123/GIT/icon-aes-dyw2/experiments/dpp0029"
        var2file["T"]="dpp0029_atm_3d_1_ml_"
        var2file["P"]="dpp0029_atm_3d_1_ml_"
        var2file["U"]="dpp0029_atm_3d_2_ml_"
        var2file["V"]="dpp0029_atm_3d_2_ml_"
        var2file["OMEGA"]="dpp0029_atm_3d_3_ml_"
        var2file["QV"]="dpp0029_atm_3d_4_ml_"
        var2file["PS"]="dpp0029_atm_2d_ml_"

        d=${start_date}
        while [ ${d} != ${end_date} ]; do 
            datestr=$(date -d "${d}" +%Y%m%d)
            file="${directory}/${var2file[${var}]}${datestr}T000000Z.nc"
            echo ${file}
            #filelist=(${filelist[@]} ${file})
            d=$(date -I -d "${d} + 1 day")
        done
        ;;
    
    "nwp0005")
        directory="/mnt/lustre01/work/mh0287/k203123/GIT/icon-aes-dyw_cldL/experiments/nwp0005"
        var2file["T"]="nwp0005_atm_3d_tp_ml_"
        var2file["P"]="nwp0005_atm_3d_tp_ml_"
        var2file["U"]="nwp0005_atm_3d_uvw_ml_"
        var2file["V"]="nwp0005_atm_3d_uvw_ml_"
        var2file["W"]="nwp0005_atm_3d_uvw_ml_"
        var2file["QV"]="nwp0005_atm_3d_q_ml_"
        var2file["PS"]="nwp0005_atm_2d_ml_"

        d=${start_date}
        while [ ${d} != ${end_date} ]; do 
            datestr=$(date -d "${d}" +%Y%m%d)
            file="${directory}/${var2file[${var}]}${datestr}T000000Z.nc"
            echo ${file}
            #filelist=(${filelist[@]} ${file})
            d=$(date -I -d "${d} + 1 day")
        done
        ;;
        
    *)
        echo "Run ${run} unknown"
        ;;
esac