import os
from scipy.io import loadmat
import pandas as pd

def get_df(path='data'):
    nar = [mat for mat in os.listdir(path) if 'nar_' in mat]
    narx = [mat for mat in os.listdir(path) if 'narx_' in mat]
    nar.extend(narx)
    res = pd.DataFrame()
    for f in nar:
        mat=loadmat(os.path.join(path,f))
        res=res.append([[f.split('_')[0],
                         f.split('_')[1],
                         f.split('_')[2],
                         f.split('_')[3].split('.')[0],
                         mat['performance'].ravel()[0],
                         mat['trainPerformance'].ravel()[0],
                         mat['valPerformance'].ravel()[0],
                         mat['testPerformance'].ravel()[0]
                         ]], ignore_index=True)
    res[2] = res[2].astype(int)
    res[3] = res[3].astype(int)
    res[4] = res[4].astype(float)
    res[5] = res[5].astype(float)
    res[6] = res[6].astype(float)
    res[7] = res[7].astype(float)
    res.columns=['model','train_fcn','delay','layers','mse','train_mse','val_mse','test_mse']
    return res