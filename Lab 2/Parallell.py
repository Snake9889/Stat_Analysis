import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sklearn
from tqdm import tqdm
from sklearn.linear_model import LogisticRegression
import multiprocessing as mp


def recombination(data_array):
    """   """
    gen_pairs = []
    for i in range(20):
        for j in range(i+1, 20):
            gen_pairs.append([i, j])
    types = [[0, 0], [0, 1], [1, 0], [1, 1]]
    
    for i in tqdm(range(len(gen_pairs))):
        for j in range(len(types)):
            columns = "(%d,%d)_(%d,%d)" % (gen_pairs[i][0], gen_pairs[i][1], types[j][0], types[j][1])
            for k in data_array.index.tolist():
                if (data_array["Position_gen %d" % (gen_pairs[i][0])][k] == types[j][0]) and (data_array["Position_gen %d" % (gen_pairs[i][1])][k] == types[j][1]):
                    data_array.loc[k, columns] = 1
                else:
                    data_array.loc[k, columns] = 0
    return data_array


def parallelization(data_array, method):
    partitions = 6
    workers = 6
    data_splited = np.array_split(data_array, partitions)
    pool = mp.Pool(workers)
    data_array = pd.concat(pool.map(method, data_splited))
    pool.close()
    pool.join()
    return data_array
