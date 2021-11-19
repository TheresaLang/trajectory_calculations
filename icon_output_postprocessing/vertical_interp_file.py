#!/usr/bin/env python
#SBATCH --job-name=vertical_interpolation
#SBATCH --output=logs/vertical_interpolation-%j.out
##SBATCH --error=logs/vertical_interpolation-%j.err

#SBATCH --account=mh1126       # Charge resources on this project account
#SBATCH --partition=compute,compute2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=36     # Specify number of CPUs per task
#SBATCH --time=05:00:00        # Set a limit on the total run time
#SBATCH --mem=0                # use all memory on node
#SBATCH --constraint=256G      # only run on fat memory nodes
#SBATCH --monitoring=meminfo=10,cpu=5,lustre=5

import sys
import numpy as np
import xarray as xr
from scipy.interpolate import interp1d
import multiprocessing as mp

def interp_subfield(subfield, heights_old, heights_new, variable):
    log_variables = ["P", "QV"]
    field_interp = xr.zeros_like(subfield)
    for la in range(field_interp.shape[2]):
        for lo in range(field_interp.shape[3]):
            if variable in log_variables:
                field_interp[0, :, la, lo] = np.exp(interp1d(
                    heights_old[:, la, lo],
                    np.log(subfield[0, :, la, lo]),
                    kind='linear',
                    fill_value='extrapolate')(heights_new[:, la, lo]))
            else:
                field_interp[0, :, la, lo] = interp1d(
                    heights_old[:, la, lo],
                    subfield[0, :, la, lo],
                    kind='linear',
                    fill_value='extrapolate')(heights_new[:, la, lo])

    return field_interp
    
arg = sys.argv
vgrid_file = arg[1]
p_file_in = arg[2]
s_file_in = arg[3]
p_file_out = arg[4]
s_file_out = arg[5]

vars_2d = ['PS', 'PW']
vars_halflevs = ['W']
other_vars = ['height_bnds']

grid = xr.load_dataset(vgrid_file)
p = xr.load_dataset(p_file_in)

# get full level heights, half level heights and new heights to interpolate on
heights_p_full = grid.z_mc_full.sel(height_2=p.height)
heights_p_half = grid.z_mc.sel(height=p.height_2)
heights_full_new = heights_p_half[:-1] + 0.5*np.diff(heights_p_half, axis=0)

# calculate sizes of sub-arrays for parallelization
num_processes = 36
chunk_size = int(np.ceil(p.lon.shape[0] / num_processes))
lon_bins = np.arange(0, p.lon.shape[0]+chunk_size, chunk_size)

# split height arrays into sub-arrays
heights_p_full_split = []
heights_full_new_split = []
for i in range(len(lon_bins)-1):
    heights_p_full_split.append(heights_p_full.isel(lon=slice(lon_bins[i], lon_bins[i+1])))
    heights_full_new_split.append(heights_full_new.isel(lon=slice(lon_bins[i], lon_bins[i+1])))
    
# loop over files (p and s file)
for file_in, file_out in zip([p_file_in, s_file_in], [p_file_out, s_file_out]):
    # load p or s data
    p = xr.load_dataset(file_in)
    # new dataset for interpolated data
    p_new = xr.Dataset()

    # get list of variables that need to be interpolated
    vars_interp = list(p.keys())
    for v in vars_2d+vars_halflevs+other_vars:
        if v in vars_interp:
            vars_interp.remove(v)
    
    # loop over variables that need to be interpolated
    for v in vars_interp:
        print(v)
        # split into sub-arrays
        subfields = []
        for i in range(len(lon_bins)-1):
            subfields.append(p[v].isel(lon=slice(lon_bins[i], lon_bins[i+1])))
        
        # perform interpolation in parallel for each sub-array 
        with mp.Pool(processes=num_processes) as pool:
            results = [pool.apply_async(interp_subfield, args=(subfields[i], heights_p_full_split[i], heights_full_new_split[i], v)) for i in range(num_processes)] 
            interp_arr_list = [res.get() for res in results]
        
        # recombine sub-arrays
        field_interp = xr.concat(interp_arr_list, dim="lon")
        # add interpolated field to dataset
        p_new[v] = field_interp
    # save dataset as netcdf
    p_new.to_netcdf(file_out)
    # close datasets
    p.close()
    p_new.close()