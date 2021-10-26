#!/bin/bash

source run_config

d_start=${first_start_time}
    while [ "${d_start}" != "${last_start_time}" ]; do
        echo ${d_start}
        d_end=$(date -d "${d_start} ${trajectory_length} hours ago" "+%Y-%m-%d %H:%M")
        bash ./caltra_one_start_time.sh "${d_start}" "${d_end}"
        d_start=$(date -d "${d_start} ${start_time_interval} hours" "+%Y-%m-%d %H:%M")
    done

