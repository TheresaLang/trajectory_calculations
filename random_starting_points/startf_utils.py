import numpy as np
from netCDF4 import Dataset
import random
from global_land_mask import globe

def read_lat_lon(file):
    """ Reat latitudes and longitudes from file.
    
    Parameters:
        file (str): full path to file
    
    Returns:
        1darray: latitude [deg north]
        1darray: longitude [deg east]
    """
    
    with Dataset(file) as ds:
        lon = ds.variables["lon"][:].filled(np.nan)
        lat = ds.variables["lat"][:].filled(np.nan)
        
    return lat, lon

def read_variable(file, varname):
    """ Read variable from netCDF file.
    
    Parameters:
        file (str): full path to file
    
    Returns:
        ndarray: variable field
    """
    
    with Dataset(file) as ds:
        var = ds.variables[varname][:].filled(np.nan)
    
    return var[0] if var.shape[0] == 1 else var

def calc_fth(rh, z, layer_thickness, z_start=4000, z_end=8000):
    """ Calculate mean relative humidity over a given altitude layer.
    All input parameters should have dimensions (height, lat, lon).
    
    Parameters:
        rh (3darray): relative humidity
        z (3darray): geometric height of model levels in m
        layer_thickness (3darray): thickness of model levels in m
        z_start (float): lower boundary of FTH layer in m
        z_end (float): upper boundary of FTH layer in m
        
    Returns:
        3darray: mean relative humidity in specified altitude layer
    """
    
    fth = np.empty_like(rh[0])
    fth[:] = np.nan
    
    for la in range(rh.shape[1]):
        for lo in range(rh.shape[2]):
            # determine height levels between z_start and z_end
            ind_fth = np.logical_and(z[:, la, lo] > z_start, z[:, la, lo] < z_end)
            # calculate mean rh in these levels (weight with level thickness)
            fth[la, lo] = np.average(rh[ind_fth, la, lo], weights=layer_thickness[ind_fth, la, lo], axis=0)
    
    # set FTH to nan, where mountains protrude into the FTH layer
    fth[z[-1] > z_start] = np.nan
        
    return fth

def create_random_indices(mask, num_samples):
    """ Create arrays of random x and y indices for a 2D array ``mask``.
    Indices are only drawn from points where ``mask`` equals 1.
    
    Parameters:
        mask (2d array of bool): array from which random samples are drawn
        num_samples (int): number of random samples
        
    Returns:
        1darray: x indices
        1darray: y indices
    """
    
    mask_ind = np.where(mask)
    x_not_masked = mask_ind[0]
    y_not_masked = mask_ind[1]

    r = random.sample(list(zip(x_not_masked, y_not_masked)), num_samples)
    x_inds, y_inds = zip(*r)
        
    return x_inds, y_inds

def rand_coords_from_field(lat, lon, field, field_start, field_end, num_coordinates, ocean_only=True):
    """ Returns random coordinates that lie inside the tropics, over ocean
    and within a certain PW (precipitable water) range.
    
    Parameters:
        lat (1darray): latitude [deg north]
        lon (1darray): longitude [deg east]
        field (2darray): field (e.g. precipitable water, upper tropospheric rel. humidity)
        field_start (float): lower bound field
        field_end (float): upper bound for field
        num_coordinates (int): number of random coordinates
        ocean_only (boolean): chose only points over ocean
        
    Returns:
        1darray: random latitude values
        1darray: random longitude values
    """
    lon_grid, lat_grid = np.meshgrid(lon, lat)
    if ocean_only:
        is_ocean = globe.is_ocean(lat_grid, lon_grid)
    is_tropic = np.abs(lat_grid) <= 30.
    if ocean_only:
        is_tropic = np.logical_and(is_ocean, is_tropic)
    
    if field_end is None:
        is_field_in_range = is_tropic
    else:
        is_in_field_range = np.logical_and(field >= field_start, field <= field_end)
        
    is_tropic_in_range = np.logical_and(is_in_field_range, is_tropic)
    rand_lat_ind, rand_lon_ind = create_random_indices(is_tropic_in_range, num_coordinates)
    rand_lat = np.array([lat[ind] for ind in rand_lat_ind])
    rand_lon= np.array([lon[ind] for ind in rand_lon_ind])
    
    return rand_lat, rand_lon

def rand_heights(height_bounds, size):
    """ Returns random heights between height_bounds.
    
    Parameters:
        height_bounds (list of float): Lower and upper bound for heights
        size (int): Number of random heights
    """
    return np.random.random_sample(size) * (height_bounds[1] - height_bounds[0]) + height_bounds[0]

def write_startf(file, rand_lat, rand_lon, rand_heights):
    """ Write startf file that contains start positions for trajectories for lagranto.
    
    Parameters:
        file (str): Full path to startf file
        rand_lat (1darray): random latitudes [deg north]
        rand_lon (1darray): random longitudes [deg east]
        rand_heights (1darray): random heights [m]
    """
    with open(file, 'x') as f:
        for la, lo, h in zip(rand_lon, rand_lat, rand_heights):
            f.write('{0:10.3f}{1:10.3f}{2:10.3f}\n'.format(la, lo, h))

