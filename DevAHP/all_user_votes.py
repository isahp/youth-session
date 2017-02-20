'''
Created on Aug 19, 2016

@author: wjadams
'''

import numpy as np
import plotly.graph_objs as go
from plotly.offline import download_plotlyjs, init_notebook_mode, iplot
from math_calcs import largest_eigen, random_consistency
from math import floor

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

def geometric_avg(listOfMats):
    #Create rval
    rval = np.zeros_like(listOfMats[0])
    nrows = rval.shape[0]
    ncols = rval.shape[1]
    for row in range(nrows):
        for col in range(ncols):
            val = 1
            count = 0
            for mat in listOfMats:
                if mat[row, col]!=0:
                    val *= mat[row,col]
                    count+=1
            if count != 0:
                val = pow(val, 1.0/count)
            #Finally have the value, put it in
            rval[row,col] = val
    return rval


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
        self.sym_vote_values = [3, 9]
        self.default_votes = None
        
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
        
    def get_matrix_raw(self, user):
        if isinstance(user, str):
            #Need to get user position
            user = self.user_names.index(user)
        rval = self.user_votes[user].copy()
        return(rval)
    
    def get_sym_vote_value(self, vote, sym_vote_values = None):
        if sym_vote_values is None:
            sym_vote_values = self.sym_vote_values
        if floor(vote) == vote:
            intVote = abs(int(vote)) - 1
            if intVote < len(sym_vote_values):
                #Okay the vote is within the list of sym values
                return(sym_vote_values[intVote])
            else:
                #Past the end, we just assume a continued exponential growth from the last value
                #where the base is (last_value)^(1/length)
                base = sym_vote_values[len(sym_vote_values)-1] ** (1.0/len(sym_vote_values))
                diff = intVote - len(sym_vote_values) + 1
                return(base ** diff)
        else:
            intVote = int(vote+0.5)
            return(1.0/self.get_sym_vote_value(intVote, sym_vote_values=sym_vote_values))
        
    def get_vote_value(self, vote, sym_vote_values = None):
        if vote >= 0:
            return(vote)
        else:
            return(self.get_sym_vote_value(vote, sym_vote_values))
            
    def get_matrix(self, user, sym_vote_values = None, doppelganger = False):
        if isinstance(user, str):
            #Need to get user position
            user = self.user_names.index(user)
        rval = self.user_votes[user].copy()
        for row in range(rval.shape[0]):
            for col in range(rval.shape[1]):
                data = rval[row, col]
                rval[row, col] = self.get_vote_value(data, sym_vote_values=sym_vote_values)
        if doppelganger:
            return(np.transpose(rval))
        else:
            return(rval)
        
    def single_stats(self, user_name, bars = False, sym_vote_values = None, doppelganger = False):
        if bars:
            eigen = self.single_stats(user_name, bars = False, sym_vote_values = sym_vote_values, doppelganger = doppelganger)
            data = go.Bar(x=self.alt_names, y=eigen)
            layout = go.Layout(title = user_name+"'s Priorities")
            return iplot(go.Figure(data = go.Data([data]), layout = layout))
    
        else:
            return largest_eigen(self.get_matrix(user_name, sym_vote_values = sym_vote_values, doppelganger=doppelganger))
        
    def group_stats(self, user_names, bars = False, sym_vote_values = None, doppelganger = False):
        if bars:
            pass
        else:
            all_matrices = [self.get_matrix(user_name, sym_vote_values=sym_vote_values, doppelganger=doppelganger)
                            for user_name in user_names]
            geomAvg = geometric_avg(all_matrices)
            return largest_eigen(geomAvg)
        
    def inconsistency(self, user_name, sym_vote_values = None):
        mat = self.get_matrix(user_name, sym_vote_values)
        eigen = largest_eigen(mat, value_only = True)
        size = mat.shape[0]
        return (eigen-size)/(random_consistency(size)*(size-1))
    
a = PairwiseAllUsers()

def inv_vote(vote):
    if vote < 0:
        if floor(vote) == vote:
            return vote - 0.5
        else:
            return vote + 0.5
    else:
        if vote == 0.0:
            return 0.0
        else:
            return 1.0/vote

