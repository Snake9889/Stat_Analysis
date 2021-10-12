import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sklearn
from tqdm import tqdm
from sklearn.linear_model import LogisticRegression
import multiprocessing as mp


def Log_Regression_parallel(regression, Cancer, method):
    gen_pairs_2 = []
    columns = regression.columns
    for i in tqdm(range(len(columns))):
        for j in range(i, len(columns)):
            if i != j:
                gen_pairs_2.append(pd.concat((Cancer, regression[[columns[i], columns[j]]]), axis=1))
        
    #num_partitions = 80  # количество частей, на которые будет разбит дейта-фрейм
    num_workers = 8

    pool = mp.Pool(num_workers)
    data = pool.map(method, gen_pairs_2)
    
    pool.close()
    pool.join()
    return data


def Log_R(data):
    col = data.columns
    X = np.reshape(np.array(data[[col[1], col[2]]]), (-1, 2))
    Y = np.array(data[col[0]])

    LogReg = LogisticRegression(penalty='none').fit(X, Y)
    return [LogReg.score(X, Y), data.columns[1] + " " + data.columns[2]]