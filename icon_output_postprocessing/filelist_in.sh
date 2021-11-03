#!/bin/bash

run=$1
var=$2
start_date="$3"
end_date="$4"

filelist=()
declare -A var2file

case ${run} in
    "hsc0030" | "hsc0032" | "hsc0034" | "hsc0035" | "hsc0036")
        directory="/work/mh0066/m218038/models/avr/icon-aes/experiments/${run}"
        var2file["T"]="${run}_atm_traj_3d_t_ml_"
        var2file["P"]="${run}_atm_traj_3d_pres_ml_"
        var2file["U"]="${run}_atm_traj_3d_u_ml_"
        var2file["V"]="${run}_atm_traj_3d_v_ml_"
        var2file["W"]="${run}_atm_traj_3d_w_ml_"
        var2file["QV"]="${run}_atm_traj_3d_qv_ml_"
        var2file["dQV_M"]="${run}_atm_traj_3d_dqvmig_ml_"
        var2file["dQV_T"]="${run}_atm_traj_3d_dqvvdf_ml_"
        var2file["dQV_D"]="${run}_atm_traj_3d_dqvdyn_ml_"
        var2file["PS"]="${run}_atm_traj_2d_ml_"
        var2file["PW"]="${run}_atm_traj_2d_ml_"

        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" +%Y%m%d)
            file="${directory}/${var2file[${var}]}${datestr}T000000Z.nc"
            echo ${file}
            #filelist=(${filelist[@]} ${file})
            d=$(date -d "${d} 1 day" "+%Y-%m-%d %H:%M")
        done
    ;;
    
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
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" +%Y%m%d)
            file="${directory}/${var2file[${var}]}${datestr}T000000Z.nc"
            echo ${file}
            #filelist=(${filelist[@]} ${file})
            d=$(date -d "${d} 1 day" "+%Y-%m-%d %H:%M")
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
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" +%Y%m%d)
            file="${directory}/${var2file[${var}]}${datestr}T000000Z.nc"
            echo ${file}
            #filelist=(${filelist[@]} ${file})
            d=$(date -d "${d} 1 day" "+%Y-%m-%d %H:%M")
        done
        ;;

    "ots0001" | "ots0001_1")
        directory='/mnt/lustre02/work/bm1183/OTS/experiments/ots0001'
        var2file["T"]="ots0001_atm_3d_t_ml_"
        var2file["P"]="ots0001_atm_3d_pres_ml_"
        var2file["U"]="ots0001_atm_3d_u_ml_"
        var2file["V"]="ots0001_atm_3d_v_ml_"
        var2file["W"]="ots0001_atm_3d_w_ml_"
        var2file["QV"]="ots0001_atm_3d_qv_ml_"
        var2file["PS"]="ots0001_atm2_2d_ml_"
        var2file["PW"]="ots0001_atm1_2d_ml_"
        var2file["TQC"]="ots0001_atm1_2d_ml_"
        var2file["TQI"]="ots0001_atm1_2d_ml_"
        var2file["TQR"]="ots0001_atm1_2d_ml_"
        var2file["TQS"]="ots0001_atm1_2d_ml_"
        var2file["TQG"]="ots0001_atm1_2d_ml_"
        var2file["OLR"]="ots0001_atm_2d_avg_ml_"
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do
            datestr=$(date -d "${d}" +%Y%m%dT%H%M%SZ)
            file="${directory}/${var2file[${var}]}${datestr}.nc"
            echo ${file}
            #filelist=(${filelist[@]} ${file})
            if [[ ${var} =~ ^(PS|PW|TQI|TQC|TQR|TQS|TQG)$ ]]; then      
                d=$(date -d "${d} 1 day" "+%Y-%m-%d %H:%M")
            else 
                d=$(date -d "${d} 3 hours" "+%Y-%m-%d %H:%M")
            fi
        done
        ;;        
    
    "DYAMOND_S_5km")
        directory="/work/ka1081/DYAMOND/ICON-5km"
        var2file["T"]="nwp_R2B09_lkm1006_atm_3d_t_ml_"
        var2file["P"]="nwp_R2B09_lkm1006_atm_3d_pres_ml_"
        var2file["U"]="nwp_R2B09_lkm1006_atm_3d_u_ml_"
        var2file["V"]="nwp_R2B09_lkm1006_atm_3d_v_ml_"
        var2file["W"]="nwp_R2B09_lkm1006_atm_3d_w_ml_"
        var2file["QV"]="nwp_R2B09_lkm1006_atm_3d_qv_ml_"
        var2file["PS"]="nwp_R2B09_lkm1006_atm2_2d_ml_"
        var2file["PW"]="nwp_R2B09_lkm1006_atm1_2d_ml_"
        var2file["QI"]="nwp_R2B09_lkm1006_atm_3d_tot_qi_dia_ml_"
        var2file["QC"]="nwp_R2B09_lkm1006_atm_3d_tot_qc_dia_ml_"
        var2file["TQG"]="nwp_R2B09_lkm1006_atm1_2d_ml_"
        var2file["TQR"]="nwp_R2B09_lkm1006_atm3_2d_ml_"
        var2file["TQS"]="nwp_R2B09_lkm1006_atm1_2d_ml_"
	
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" +%Y%m%d)
            file="${directory}/${var2file[${var}]}${datestr}T000000Z.grb"
            echo ${file}
            #filelist=(${filelist[@]} ${file})
            d=$(date -d "${d} 1 day" "+%Y-%m-%d %H:%M")
        done
        ;;
     
    "dap0013")
        directory="/mnt/lustre01/work/mh0287/m300466/icon-dc/experiments/dap0013-dc"
        var2file["T"]="dap0013-dc_atm_3d_3_ml_"
        var2file["P"]="dap0013-dc_atm_3d_1_ml_"
        var2file["U"]="dap0013-dc_atm_3d_2_ml_"
        var2file["V"]="dap0013-dc_atm_3d_2_ml_"
        var2file["QV"]="dap0013-dc_atm_3d_3_ml_"
        var2file["PS"]="dap0013-dc_atm_2d_ml_"
        var2file["PW"]="dap0013-dc_atm_2d_ml_"

        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do
            datestr=$(date -d "${d}" +%Y%m%d)
            file="${directory}/${var2file[${var}]}${datestr}T000000Z.nc"
            echo ${file}
            #filelist=(${filelist[@]} ${file})
            d=$(date -d "${d} 1 day" "+%Y-%m-%d %H:%M")
        done
        ;;
    
    *)
        echo "Run ${run} unknown"
        ;;
esac
