'''
Created on Dec 5, 2016

@author: wjadams
'''
import numpy as np

class AhpNode(object):
    
    def __init__(self, parent_tree, name, nalts, pw=None):
        self.children = []
        self.name = name
        self.alt_scores = np.zeros([nalts])
        self.nalts = nalts
        self.parent_tree = parent_tree
        self.pw = pw
        if pw != None:
            self.add_children_pw(pw)
        
    def add_children_pw(self, pw):
        for alt_name in pw.alt_names:
            self.add_child(alt_name)
            
    def add_child(self, alt_name):
        self.children.append(AhpNode(self.parent_tree, alt_name, self.nalts))
        
    def add_alt(self):
        self.alt_scores = np.append(self.alt_scores, 0)
        self.nalts += 1
        for child in self.children:
            child.add_alt()
            
    def set_alt_scores_old(self, new_scores):
        if (len(new_scores)!=self.nalts):
            raise NameError("Wrong length for new alt scores")
        self.alt_scores = np.array(new_scores)
        self.alt_scores = self.alt_scores
        
    def set_pw(self, pw):
        if pw.nalts() != self.nchildren():
            raise NameError("Wrong number of children in Pairwise")
        self.pw = pw
        
    def nchildren(self):
        return len(self.children)
        
    def has_children(self):
        return len(self.children) != 0
    
    def set_alt_scores(self, vals):
        nvals = np.array(vals)
        s = np.max(nvals)
        if s != 0:
            nvals /= s
        self.alt_scores = nvals
    
    def synthesize(self, user = None):
        if not self.has_children():
            return(self.alt_scores)
        #This node has children
        rval = np.zeros([self.nalts])
        if (self.pw is not None) and (user is not None):
            coeffs = self.pw.single_stats(user)
        else:
            coeffs = np.array([0 for i in self.children])
        #print(rval)
        count = 0
        i = 0
        for kid in self.children:
            kid_vals = kid.synthesize(user)
            if np.max(kid_vals) > 0:
                count+=1
            rval += coeffs[i] * kid_vals
            i += 1
        if count > 0:
            rval /= (count+0.0)
        return(rval)
    
    def get_child(self, node_path_list):
        if len(node_path_list) <= 0:
            return(self)
        for child in self.children:
            if child.name == node_path_list[0]:
                return(child.get_child(node_path_list[1:]))
        #If we make it here, we could not find a child
        raise NameError("Could not find child `"+node_path_list[0]+"'")
    
class AhpTree(object):
    
    def __init__(self, alt_names=None, pw=None):
        self.usernames = []
        if alt_names == None:
            alt_names = []
        self.nalts = len(alt_names)
        self.alt_names = alt_names
        self.root = AhpNode(self, "root", self.nalts, pw)
        
    def add_alt(self, alt_name):
        self.alt_names.append(alt_name)
        self.root.add_alt()
        
    def synthesize(self, user=None):
        return self.root.synthesize(user)
    
    def get_node(self, node_path_list):
        return self.root.get_child(node_path_list)    