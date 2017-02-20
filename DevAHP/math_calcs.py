'''
Created on Aug 21, 2016

@author: wjadams
'''
import numpy as np

def close_enough(nextVal, currentVal, error = 1e-7):
    '''
    Are matrices class enough to consider them essentially equal
    :param nextVal:
    :param currentVal:
    :param error:
    '''
    diff = nextVal - currentVal
    diff = abs(diff)
    maxdiff = max(diff)
    if maxdiff < error:
        return True
    else:
        return False


def harker_fix(x):
    rval = x.copy()
    size = x.shape[0]
    for row in range(size):
        for col in range(size):
            if rval[row,col] == 0:
                rval[row,row] += 1
    return rval

def largest_eigen(x, error = 1e-7, value_only = False, do_harker_fix=True):
    size = x.shape[0]
    currentVal = np.array([1./size for i in range(size)])
    eigen_value = 0
    if do_harker_fix:
        x = harker_fix(x)
    while True:
        nextVal = np.matmul(x, currentVal)
        eigen_value = sum(nextVal)
        nextVal = nextVal / eigen_value
        #print "Working Still"
        if close_enough(nextVal, currentVal, error = 1e-7):
            if value_only:
                return eigen_value
            else:
                return nextVal
        currentVal = nextVal
    if value_only:
        return eigen_value
    else:
        return currentVal

def random_consistency(n):
    if n <= 1:
        return 1
    elif n == 2:
        return 1
    elif n == 3:
        return 0.52
    elif n == 4:
        return 0.89
    elif n == 5:
        return 1.12
    elif n == 6:
        return 1.25
    elif n == 7:
        return 1.35
    elif n == 8:
        return 1.40
    elif n == 9:
        return 1.45
    elif n == 10:
        return 1.49
    elif n == 11:
        return 1.51
    elif n == 12:
        return 1.54
    elif n == 13:
        return 1.56
    elif n == 14:
        return 1.57
    elif n == 15:
        return 1.58
    else:
        return 1.98*(1-2.0/n)