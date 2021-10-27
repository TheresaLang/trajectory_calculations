#!/usr/bin/env python
#SBATCH --output=logs/create_startf-%j.out
##SBATCH --error=logs/create_startf-%j.err

#SBATCH --account=mh1126             # Charge resources on this project account
#SBATCH --ntasks=1                   # max. number of tasks to be invoked
##SBATCH --mem=0                      # use all memory on node
##SBATCH --mail-type=FAIL            # Notify user by email in case of job failure

import sys
import numpy as np
from os.path import join
from datetime import datetime, timedelta
import startf_utils as utils

arg = sys.argv
exp_name = arg[1]
lagranto_run_dir = arg[2]
first_start_date = datetime.strptime(arg[3], '%Y-%m-%d %H:%M')
last_start_date = datetime.strptime(arg[4], '%Y-%m-%d %H:%M')
start_time_interval = timedelta(hours=float(arg[5]))
num_traj_per_start_time = int(arg[6])
num_batches = int(arg[7])
pw_start = float(arg[8])
pw_end = float(arg[9])
height_bounds = [float(arg[10]), float(arg[11])]

date = first_start_date
while date <= last_start_date:
    # filenames
    date_str = date.strftime("%Y%m%d_%H")
    pw_file = join(lagranto_run_dir, f"S{date_str}")
    startf_file = join(lagranto_run_dir, f"{exp_name}_startf_{date_str}")
    # read PW from file
    lat, lon = utils.read_lat_lon(pw_file)
    pw = utils.read_var(pw_file, 'PW')
    # get random coordinates in a specified range of PW
    rand_lat, rand_lon = utils.rand_coords_from_pw(lat, lon, pw, pw_start, pw_end, num_traj_per_start_time)
    rand_heights = utils.rand_heights(height_bounds, num_traj_per_start_time)
    # split into batches
    rand_lat_split = np.array_split(rand_lat, num_batches)
    rand_lon_split = np.array_split(rand_lon, num_batches)
    heights_split = np.array_split(rand_heights, num_batches)
    # write coordinates to startf file
    for i in range(num_batches):
        utils.write_startf(f"{startf_file}_{i}", rand_lat_split[i], rand_lon_split[i], heights_split[i])

    date += start_time_interval
