#!/bin/bash

source run_config

d_start=${first_start_time}
while [ "${d_start}" != "${last_start_time}" ]; do
    bash ./trace_one_start_time.sh "${d_start}"
    d_start=$(date -d "${d_start} ${start_time_interval} hours" "+%Y-%m-%d %H:%M")
done

