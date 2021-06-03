#!/bin/bash

out_dir=$1
run=$2
var=$3
start_date=$4
end_date=$5

filelist=()
directory="${out_dir}/${run}"
case ${run} in

    "dpp0029")
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" +%Y%m%d)
            file="${directory}/${var}_${datestr}_"
            echo ${file}
            d=$(date -d "${d} + 1 day" "+%Y-%m-%d %H:%M")
        done
        ;;
    
    "nwp0005")
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" +%Y%m%d)
            file="${directory}/${var}_${datestr}_"
            echo ${file}
            d=$(date -d "${d} + 1 day" "+%Y-%m-%d %H:%M")
        done
        ;;

    "ots0001")
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" +%Y%m%d_%H%M)
            file="${directory}/${var}_${datestr}_"
            echo ${file}
            if [[ ${var} == 'PS' || ${var} == 'PW' ]]; then
                d=$(date -d "${d} + 1 day" "+%Y-%m-%d %H:%M")
            else
                d=$(date -d "${d} 3 hours" "+%Y-%m-%d %H:%M")
            fi
        done
        ;;
    *)
        echo "Run ${run} unknown"
        ;;
esac
