#!/bin/bash

run=$1
var=$2

declare -A variable_name
case ${run} in
    "dpp0029")
        variable_name["T"]="ta"
        variable_name["P"]="pfull"
        variable_name["U"]="ua"
        variable_name["V"]="va"
        variable_name["OMEGA"]="wap"
        variable_name["QV"]="hus"
        variable_name["PS"]="ps"

        echo ${variable_name[${var}]}
        ;;
        
    "nwp0005")
        variable_name["T"]="temp"
        variable_name["P"]="pres"
        variable_name["U"]="u"
        variable_name["V"]="v"
        variable_name["W"]="w"
        variable_name["QV"]="qv"
        variable_name["PS"]="pres_sfc"

        echo ${variable_name[${var}]}
        ;;
    
    *)
        echo "Run ${run} unknown"
        ;;
esac

