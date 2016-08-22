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


def largest_eigen(x, error = 1e-7):
    size = x.shape[0]
    currentVal = np.array([1./size for i in range(size)])
    while True:
        nextVal = np.matmul(x, currentVal)
        nextVal = nextVal / sum(nextVal)
        #print "Working Still"
        if close_enough(nextVal, currentVal, error = 1e-7):
            return nextVal
        currentVal = nextVal
    return currentVal
