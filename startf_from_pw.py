import numpy as np
from netCDF4 import Dataset
from os.path import join
import random
import datetime
import matplotlib.pyplot as plt
from global_land_mask import globe
import typhon
import logging
import startf_utils as utils

startf_dir = "/mnt/lustre02/work/um0878/users/tlang/work/rh_sensitivity/lagranto/runscripts/ots0001"
pw_dir = "/mnt/lustre02/work/mh1126/m300773/lagranto_input/ots0001"
start_date = datetime.datetime(2020, 2, 8, 23, 0)
end_date = datetime.datetime(2020, 2, 8, 23, 30)
timestep = datetime.timedelta(minutes=30)
num_trajectories = 1000
pw_start = 25
pw_end = 37 
heights = [5000]

date = start_date
while date <= end_date:
    # filenames
    date_str = date.strftime("%Y%m%d_%H%M")
    pw_file = join(pw_dir, f"S{date_str}")
    startf_file = join(startf_dir, f"startf_{date_str}")
    # read PW from file
    lat, lon, pw = utils.read_pw(pw_file)
    # get random coordinates in a specified range of PW
    rand_lat, rand_lon = utils.rand_coords_from_pw(lat, lon, pw, pw_start, pw_end, num_trajectories)
    # write coordinates to startf file
    utils.write_startf(startf_file, rand_lat, rand_lon, heights)

    date += timestep



