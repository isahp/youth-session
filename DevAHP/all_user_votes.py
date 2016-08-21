'''
Created on Aug 19, 2016

@author: wjadams
'''

import numpy as np
import plotly.graph_objs as go
from plotly.offline import download_plotlyjs, init_notebook_mode, iplot
from math_calcs import largest_eigen

def add_place(np_array):
    if np_array.shape == (0, 0):
        return(np.identity(1))
    else:
        size = np_array.shape[0]
        extraCol = [0 for i in range(size)]
        np_array = np.insert(np_array, [size], extraCol, axis=1)
        extra_row = [0 for i in range(size+1)]
        extra_row[size] = 1
        np_array = np.insert(np_array, [size], extra_row, axis = 0)
        return(np_array)


class PairwiseAllUsers(object):
    '''
    This represents all user votes on a particular pairwise comparison
    '''

    def __init__(self):
        '''
        Constructor
        '''
        self.user_votes = []
        self.user_names = []
        self.alt_names = []
        
    def clear(self):
        self.user_votes = []
        self.user_names = []
        self.alt_names = []
        
        
    def __str__(self):
        return self.user_votes.__str__()

    def nalts(self):
        return(len(self.alt_names))
    
    def add_user(self, userName, matrix = None):
        if userName in self.user_names:
            raise(NameError("User already existed"))
        if matrix is None:
            pw = np.identity(self.nalts())
        else:
            pw = matrix
        self.user_votes.append(pw)
        self.user_names.append(userName)
        
    def add_alt(self, alt_name):
        if alt_name in self.alt_names:
            raise(NameError("Alt already existed"))
        self.alt_names.append(alt_name)
        for i in range(len(self.user_names)):
            vs = self.user_votes[i]
            self.user_votes[i] = add_place(vs)
    
    def pw(self, user, row, col, val):
        if isinstance(user, str):
            #Need to get user position
            user = self.user_names.index(user)
        if isinstance(row, str):
            row = self.alt_names.index(row)
        if isinstance(col, str):
            col = self.alt_names.index(col)
        votes = self.user_votes[user]
        votes[row, col] = val
        if val != 0:
            votes[col, row] = 1.0/val
        else:
            votes[col, row] = 0.0
        
    def get_matrix(self, user):
        if isinstance(user, str):
            #Need to get user position
            user = self.user_names.index(user)
        return(self.user_votes[user])
        
    def single_stats(self, user_name, bars = False, better = 3,  muchbetter = 9, doppelganger = False):
        if bars:
            eigen = self.single_stats(user_name, bars = False, better = better, muchbetter = muchbetter, doppelganger = doppelganger)
            data = go.Bar(x=self.alt_names, y=eigen)
            layout = go.Layout(title = user_name+"'s Priorities")
            return iplot(go.Figure(data = go.Data([data]), layout = layout))
    
        else:
            return largest_eigen(self.get_matrix(user_name))


