import sys
import numpy as np
import typhon
import xarray as xr

P_file = sys.argv[1]
S_file = sys.argv[2]
z_file = sys.argv[3]
RH_file = sys.argv[4]

def calc_crh(vmr, p, t, z, p_start=85000, p_end=30000):
    """ Calculate column relative humidity"""
    in_p_range = np.logical_and(p <= p_start, p >= p_end)
    vmr[np.logical_not(in_p_range)] = 0.
    vmr_s = typhon.physics.e_eq_mixed_mk(t) / p
    vmr_s[np.logical_not(in_p_range)] = 0.
    iwv = typhon.physics.integrate_water_vapor(vmr, p, t, z)
    iwv_s = typhon.physics.integrate_water_vapor(vmr_s, p, t, z)
    crh = iwv / iwv_s
    return crh

# read dimensions, p, T and q from files
ds_P = xr.load_dataset(P_file)
ds_S = xr.load_dataset(S_file)
ds_z = xr.load_dataset(z_file)

time = ds_P["time"]
height = ds_P["height_2"]
lon = ds_P["lon"]
lat = ds_P["lat"]
p = ds_P["P"]
t = ds_S['T']
q = ds_S['QV']
z_half = ds_z['z_mc']
z = z_half[:-1] + 0.5 * np.diff(z_half, axis=0)

# calculate RH and CRH
vmr = typhon.physics.specific_humidity2vmr(q.data) #volume mixing ratio (vmr) 
rh = typhon.physics.vmr2relative_humidity(vmr, p.data, t.data, e_eq=typhon.physics.e_eq_mixed_mk) #RH
crh = calc_crh(vmr[0], p.data[0], t.data[0], z.data) #CRH

# save
ds_RH = xr.Dataset(
    {
        "RH": (p.dims, rh),
        "CRH": (["lat", "lon"], crh)
    },
    coords = ds_P.coords
)
ds_RH.to_netcdf(RH_file)


