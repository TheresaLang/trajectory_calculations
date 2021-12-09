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
from importlib import reload 
import startf_utils as utils
import trajectory_utils

print('import')
arg = sys.argv
exp_name = arg[1]
lagranto_run_dir = arg[2]
data_dir = arg[3]
first_start_date = datetime.strptime(arg[4], '%Y-%m-%d %H:%M')
last_start_date = datetime.strptime(arg[5], '%Y-%m-%d %H:%M')
start_time_interval = timedelta(hours=float(arg[6]))
num_traj_per_start_time = int(arg[7])
percentile = float(arg[8])
#rh_end = float(arg[9])
height_bounds = [float(arg[9]), float(arg[10])]

date = first_start_date
print(arg)


while date <= last_start_date:
    print(date)
    # filenames
    date_str = date.strftime("%Y%m%d_%H%M")
    rh_file = join(data_dir, f"RH_{date_str}.nc")
    startf_file = join(lagranto_run_dir, f"{exp_name}_startf_{date_str}")
    lat, lon = utils.read_lat_lon(startf_file)
    
    if percentile == 100:
        rh_start = None
        rh_end = None
    else:
        # read RH from file
        fth = utils.read_variable(rh_file, 'FTH')
        # FTH percentiles
        rh_start = np.nanpercentile(fth, 0.)
        rh_end = np.nanpercentile(fth, percentile)

    # get random coordinates in a specified range of RH
    rand_lat, rand_lon = utils.rand_coords_from_field(lat, lon, fth, rh_start, rh_end, num_traj_per_start_time, ocean_only=False)
    rand_heights = utils.rand_heights(height_bounds, num_traj_per_start_time)
    
    # write coordinates to startf file
    utils.write_startf(startf_file, rand_lat, rand_lon, rand_heights)

    date += start_time_interval