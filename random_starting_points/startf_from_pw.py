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
percentile = float(arg[7])
height_bounds = [float(arg[8]), float(arg[9])]

date = first_start_date
while date <= last_start_date:
    # filenames
    date_str = date.strftime("%Y%m%d_%H")
    pw_file = join(lagranto_run_dir, f"S{date_str}")
    startf_file = join(lagranto_run_dir, f"{exp_name}_startf_{date_str}")
    # read PW from file
    lat, lon = utils.read_lat_lon(pw_file)
    pw = utils.read_var(pw_file, 'PW')
    # percentiles
    pw_start = np.nanpercentile(pw, 0)
    pw_end = np.nanpercentile(pw, percentile)
    # get random coordinates in a specified range of PW
    rand_lat, rand_lon = utils.rand_coords_from_field(lat, lon, pw, pw_start, pw_end, num_traj_per_start_time)
    rand_heights = utils.rand_heights(height_bounds, num_traj_per_start_time)

    # write coordinates to startf file
    utils.write_startf(startf_file, rand_lat, rand_lon, rand_heights)

    date += start_time_interval
