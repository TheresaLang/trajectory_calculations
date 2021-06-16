#!/bin/bash

run=$1
var=$2
start_date=$3
end_date=$4

filelist=()
case ${run} in

    "dpp0029")
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" "+%Y%m%d %H%M")
            echo "${datestr},"
            d=$(date -d "${d} + 1 day" "+%Y-%m-%d %H:%M")
        done
        ;;
    
    "nwp0005")
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" "+%Y%m%d %H%M")
            echo "${datestr},"
            d=$(date -d "${d} + 1 day" "+%Y-%m-%d %H:%M")
        done
        ;;

    "ots0001" | "ots0001_1")
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" "+%Y%m%d %H%M")
            echo "${datestr},"
            if [[ ${var} == 'PS' || ${var} == 'PW' ]]; then
                d=$(date -d "${d} + 1 day" "+%Y-%m-%d %H:%M")
            else
                d=$(date -d "${d} 3 hours" "+%Y-%m-%d %H:%M")
            fi
        done
        ;;
    
    "DYAMOND_S_5km")
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" "+%Y%m%d %H%M")
            echo "${datestr},"
            d=$(date -d "${d} + 1 day" "+%Y-%m-%d %H:%M")
        done
        ;;

    *)
        echo "Run ${run} unknown"
        ;;
esac
