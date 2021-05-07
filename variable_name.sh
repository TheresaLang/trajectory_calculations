#!/bin/bash

run=$1
var=$2

declare -A variable_name
case ${run} in
    "dpp0029")
        directory="/mnt/lustre01/work/mh0287/k203123/GIT/icon-aes-dyw2/experiments/dpp0029"
        variable_name["T"]="ta"
        variable_name["P"]="pfull"
        variable_name["U"]="ua"
        variable_name["V"]="va"
        variable_name["OMEGA"]="wap"
        variable_name["QV"]="hus"
        variable_name["PS"]="ps"

        echo ${variable_name[${var}]}
        ;;
    
    *)
        echo "Run ${run} unknown"
        ;;
esac

