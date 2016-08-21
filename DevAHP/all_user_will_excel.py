'''
Created on Aug 20, 2016

@author: wjadams
'''
from openpyxl import load_workbook
import numpy as np
from all_user_votes import PairwiseAllUsers

################################################################
####Begin code to parse Will's Excel File Format  ##############
################################################################

def get_altnames_will_excel(xlsxfile):
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

def get_usernames_will_excel(xlsxFile):
    wb = load_workbook(filename = xlsxFile)
    return wb.get_sheet_names()
    
def calc(x, better = 3.0, muchbetter = 9.0):
    if(x == ">"):
        return 1./better
    elif(x == ">>"):
        return 1./muchbetter
    elif(x == "<"):
        return better
    elif(x == "<<"):
        return muchbetter
    elif(x == "E"):
        return 1
    else:
        return("Error, unknown value "+ x)
    
def get_matrix_from_will(fname, sheetName, better = 3, muchbetter = 9, doppelganger = False):
    #First we need to know the alternatives in this sheet
    altnames = get_altnames_will_excel(fname)
    #The number of alternatives is the size of the return matrix
    matSize = len(altnames)
    #The return matrix starts off with 1's on the diagonal, and zeroes elsewhere
    returnMatrix = np.identity(matSize)
    #Load up the excel spreadsheet and get the actual sheet
    wb = load_workbook(filename = fname)
    xsheet = wb.get_sheet_by_name(sheetName)
    #Loop over the rows in this sheet
    for row in range(xsheet.max_row):
        #Get the first column val, which is the row of the comparison
        val1 = xsheet.cell(row = row+1, column = 1).value
        #Get the second column val, which is the value of the comparison
        val2 = xsheet.cell(row = row+1, column = 2).value
        #Get the third column value, which is the COLUMN of the comparison
        val3 = xsheet.cell(row = row+1, column = 3).value
        #If third column value == None, that means this wasn't a pairwise comparison entry
        #Maybe it was a demographic bit (FavColor)
        if (val3 != None):
            #Get the index of the alt name in the list of altnames
            #This tells us where to place the vote in the resulting matrix
            rowIndex = altnames.index(val1)
            colIndex = altnames.index(val3)
            #Get the numeric value of the vote from the stringy vote
            voteValue = calc(val2, better, muchbetter)
            #Lastly place the vote in, and it's reciprocal on the other side
            #of the diagonal
            returnMatrix[rowIndex,colIndex] = voteValue
            returnMatrix[colIndex, rowIndex] = 1./voteValue
#            returnMatrix[index3, index1] = 
    if doppelganger:
        returnMatrix = np.transpose(returnMatrix)
        
    return returnMatrix

def from_will_excel(xlsxFile, better = 3.0, muchbetter = 9.0, doppelganger = False):
    allvotes = PairwiseAllUsers()
    allvotes.clear()
    allvotes.alt_names = get_altnames_will_excel(xlsxFile)
    for user in get_usernames_will_excel(xlsxFile):
        allvotes.add_user(user, get_matrix_from_will(xlsxFile, user, better, muchbetter, doppelganger))
    return(allvotes)
################################################################
#### End code to parse Will's Excel File Format ################
################################################################



votes = PairwiseAllUsers()
print(isinstance("Fart", str))
votes.add_user("Bill")
votes.add_alt("alt1")
votes.add_alt("alt2")
votes.pw("Bill", 0, 1, 5)
votes.add_user("John")
print(votes)
votes2 = from_will_excel("Areas.xlsx")
print(votes2)
