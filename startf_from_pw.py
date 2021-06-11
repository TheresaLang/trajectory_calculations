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
heights = [5000]

date = first_start_date
while date <= last_start_date:
    # filenames
    date_str = date.strftime("%Y%m%d_%H%M")
    pw_file = join(lagranto_run_dir, f"S{date_str}")
    startf_file = join(lagranto_run_dir, f"{exp_name}_startf_{date_str}")
    # read PW from file
    lat, lon, pw = utils.read_pw(pw_file)
    # get random coordinates in a specified range of PW
    rand_lat, rand_lon = utils.rand_coords_from_pw(lat, lon, pw, pw_start, pw_end, num_traj_per_start_time)
    # write coordinates to startf file
    rand_lat_split = np.array_split(rand_lat, num_batches)
    rand_lon_split = np.array_split(rand_lon, num_batches)
    
    for i in range(num_batches):
        utils.write_startf(f"{startf_file}_{i}", rand_lat_split[i], rand_lon_split[i], heights)

    date += start_time_interval
