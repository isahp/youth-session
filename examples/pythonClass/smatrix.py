'''
Created on Aug 16, 2016

@author: dlens
'''

import numpy as np

class SMatrix(object):
    '''
    classdocs
    '''
    matrixData = np.array([])

    def __init__(self, size):
        '''
        Constructor
        '''
        self.matrixData = np.identity(size)
        
    def fromString(self, dataString, size):
        matrixEntries = dataString.split()
        count = 0
        self.matrixData = np.zeros([size, size])
        for row in range(size):
            for col in range(size):
                entry = matrixEntries[count]
                self.matrixData[row, col] = float(entry)
                count += 1

    def fromPairwiseVotes(self, dataString, size):
        matrixEntries = dataString.split()
        count = 0
        self.matrixData = np.identity(size)
        for row in range(0, size):
            for col in range(row+1, size):
                entry = matrixEntries[count]
                self.matrixData[row, col] = float(entry)
                self.matrixData[col, row] = 1/float(entry)
                count += 1
        
    def __str__(self):
        return(self.matrixData.__str__())

myMatrix = SMatrix(3)
print(myMatrix)
myMatrix.fromString("1 2 3 4", 2)
print(myMatrix)
myMatrix.fromPairwiseVotes("2 3 5", 3)
print(myMatrix)