'''
Created on Feb 23, 2016

@author: Devin
'''

from openpyxl import load_workbook
import numpy as np
from _sqlite3 import Row

#wb = load_workbook(filename = 'Areas.xlsx')

#sheet = wb.get_sheet_by_name('Sarah')
#type(sheet)

#d = [sheet.cell(row = i, column = 2).value for i in range(1, 7)]


def close_enough(nextVal, currentVal, error = 1e-7):
    diff = nextVal - currentVal
    diff = abs(diff)
    maxdiff = max(diff)
    if maxdiff < error:
        return True
    else:
        return False

def calc(x):
    if(x == ">"):
        return 3
    elif(x == ">>"):
        return 9
    elif(x == "<"):
        return 1./3
    elif(x == "<<"):
        return 1./9
    elif(x == "E"):
        return 1
    else:
        return("Error, unknown value "+ x)

def single_stats(fname, sheetname, bars = False):
    if bars:
        return "I should really do bars"
    else:
        return Largest_eigen(outMat(fname, sheetname))


def outMat(fname, x):
    wb = load_workbook(filename = fname)
    xsheet = wb.get_sheet_by_name(x)
    type(xsheet)
    f = [xsheet.cell(row = i, column = 2).value for i in range(1, 7)]
    outputArray = np.array([calc(j) for j in f])
    ab = outputArray[0]
    bc = outputArray[1]
    cd = outputArray[2]
    ac = outputArray[3]
    bd = outputArray[4]
    ad = outputArray[5]
    ba = 1./outputArray[0]
    cb = 1./outputArray[1]
    dc = 1./outputArray[2]
    ca = 1./outputArray[3]
    db = 1./outputArray[4]
    da = 1./outputArray[5]

    return np.array([[1, ab, ac, ad],
                     [ba, 1 , bc,bd],
                     [ca,  cb, 1, cd],
                     [da, db, dc, 1]])

def Largest_eigen(x, error = 1e-7):
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

def get_altnames(xlsxfile):
    wb = load_workbook(filename = xlsxfile)
    firstsheet = wb.get_sheet_names()[0]
    sheet = wb.get_sheet_by_name(firstsheet)
    nrows = sheet.max_row
    firstcol = [sheet.cell(row = i, column = 1).value for i in range(1, nrows)]
    thirdcol = [sheet.cell(row = i, column = 3).value for i in range(1, nrows)]

    rval = list()
    for row in range(0, len(firstcol)):
        if thirdcol[row] != None:
            if (firstcol[row] != None) and (firstcol[row] not in rval):
                rval.append(firstcol[row])
            if (thirdcol[row] not in rval):
                rval.append(thirdcol[row])
    return rval
    
def listtest(x):   
    list1 = list([1, 2, 5, 6, 9])
    if x not in list1:
        return "number not found"
    else:
        return "number was found"


print get_altnames('Areas.xlsx')
print listtest(6)





    