#!/bin/bash

run=$1
var=$2
start_date=$3
end_date=$4

filelist=()
case ${run} in
    "dpp0029" | "hsc0030" | "hsc0032" | "hsc0034" | "hsc0035" | "tla0001" | "nwp0005" | "dap0013" | "DYAMOND_S_5km")
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" "+%Y%m%d %H%M")
            echo "${datestr},"
            d=$(date -d "${d} 1 day" "+%Y-%m-%d %H:%M")
        done
        ;;
    
    "atm_dyamond_summer_avr03_05s")
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" "+%Y%m%d %H%M")
            echo "${datestr},"
            d=$(date -d "${d} 3 hours" "+%Y-%m-%d %H:%M")
        done
    ;;
   
    "hsc0036") 
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d} 1 hour" "+%Y%m%d %H%M")
            echo "${datestr},"
            d=$(date -d "${d} 24 hours" "+%Y-%m-%d %H:%M")
        done
        ;;

    "ots0001" | "ots0001_1")
        d=${start_date}
        while [ "${d}" != "${end_date}" ]; do 
            datestr=$(date -d "${d}" "+%Y%m%d %H%M")
            echo "${datestr},"
            if [[ ${var} =~ ^(PS|PW|TQI|TQC|TQR|TQS|TQG)$ ]]; then
                d=$(date -d "${d} 1 day" "+%Y-%m-%d %H:%M")
            else
                d=$(date -d "${d} 3 hours" "+%Y-%m-%d %H:%M")
            fi
        done
        ;;
    
    *)
        echo "Run ${run} unknown"
        ;;
esac
