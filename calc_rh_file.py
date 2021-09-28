#!/usr/bin/env python
#SBATCH --job-name=rh_calculation
#SBATCH --output=logs/rh_calculation-%j.out
##SBATCH --error=logs/rh_calculation-%j.err

#SBATCH --account=mh1126       # Charge resources on this project account
#SBATCH --partition=compute,compute2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=36     # Specify number of CPUs per task
#SBATCH --time=08:00:00        # Set a limit on the total run time
#SBATCH --mem=0                # use all memory on node
#SBATCH --constraint=256G      # only run on fat memory nodes (needed for NICAM)
#SBATCH --monitoring=meminfo=10,cpu=5,lustre=5
##SBATCH --mail-type=FAIL      # Notify user by email in case of job failure

import xarray as xr
import sys
import numpy as np
from startf_utils import calc_fth
import trajectory_utils

P_file = sys.argv[1]
S_file = sys.argv[2]
z_file = sys.argv[3]
RH_file = sys.argv[4]

# read dimensions, p, T and q from files
ds_P = xr.load_dataset(P_file)
ds_S = xr.load_dataset(S_file)
ds_z = xr.load_dataset(z_file)

time = ds_P["time"]
lon = ds_P["lon"]
lat = ds_P["lat"]
p = ds_P["P"].data[0]
t = ds_S['T'].data[0]
q = ds_S['QV'].data[0] * 1e-6
z_half = ds_z['z_mc'].data
layer_thickness = np.diff(z_half, axis=0)
z = z_half[:-1] + 0.5 * layer_thickness

# calculate RH and FTH
rh = trajectory_utils.relative_humidity(q, t, p) #RH
fth = calc_fth(rh, z, layer_thickness) #FTH

# save
rh = np.expand_dims(rh, 0)
fth = np.expand_dims(fth, 0)
ds_RH = xr.Dataset(
    {
        "RH": (ds_S["T"].dims, rh),
        "FTH": (["time", "lat", "lon"], fth)
    },
    coords = ds_S.coords
)
ds_RH.to_netcdf(RH_file)

