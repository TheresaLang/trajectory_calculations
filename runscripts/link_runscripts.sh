#!/bin/bash
set -o nounset
source run_config

ln -s $PWD/scripts/* ${lagranto_run_dir} 
ln -s $PWD/additional_input/* ${lagranto_run_dir}
cp run_config ${lagranto_run_dir}
