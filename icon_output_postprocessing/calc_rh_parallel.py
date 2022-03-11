#!/usr/bin/env python3
#SBATCH --account=mh1126
#SBATCH --job-name=rh_calc
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --mem=0
#SBATCH --output=logs/LOG.%x.run.%j.o
#SBATCH --exclusive
#SBATCH --time=08:00:00

import glob
import os
import sys
from subprocess import run
from functools import partial
from multiprocessing import Pool

def calc_rh_file(ps_files, z_file):
    dirname = os.path.dirname(ps_files[0])
    datestr = os.path.basename(ps_files[0])[1:14]
    out_file = os.path.join(dirname, "RH_"+datestr+".nc")
    args = ["python" , "calc_rh_file.py", ps_files[0], ps_files[1], z_file, out_file]
    print("+ ", " ".join(args))
    
    run(args, check=True)
    

run_id = sys.argv[1]
data_dir = f"/work/mh0287/m300773/experiments/{run_id}/lagranto_input/"
z_file = os.path.join(data_dir, "ICONCONST")
p_files = sorted(glob.glob(f"{data_dir}/P2*"))
s_files = sorted(glob.glob(f"{data_dir}/S2*"))
in_files = list(zip(p_files, s_files))

with Pool(12) as pool:
    pool.map(partial(calc_rh_file, z_file=z_file), in_files)
