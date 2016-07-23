'''
Created on Mar 1, 2016

@author: Devin
'''
import numpy as np
from commfxs import Largest_eigen

mat = np.array([[1,2],
               [0.5, 1]])

mat2 = np.array([[1, 2, 3], [0.5, 1, 4], [1./3, 1./4, 1]])

Eigen = Largest_eigen(mat)
#print "Eigen is "+str(Eigen)
#print "mat2 Eigen is "+str(Largest_eigen(mat2))