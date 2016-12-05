from openpyxl import load_workbook
import numpy as np
from all_user_votes import PairwiseAllUsers, inv_vote


def find_offset(xlsxFile):
    pass


def from_nish_excel(xlsxFile, sheetName = "Weight"):
    wb = load_workbook(xlsxFile, read_only=True)
    sheet = wb.get_sheet_by_name(sheetName)
    ncol = sheet.max_column
    nrow = sheet.max_row
    firstcol = [sheet.cell(row=i, column=1).value for i in range(1, nrow)]
    #The row holding headers is the one with first non-None value in 1st column
    for i in range(1, nrow):
        if (firstcol[i] != None):
            row_offset = i+1
            break
    #Now that we know the row_offset, we can figure out which columns have Name1 v Name2
    #format?
    header_row = [sheet.cell(row=row_offset, column=i).value for i in range(1,ncol)]
    alts = []
    for i in range(len(header_row)):
        thestr = header_row[i].lower().strip()
        info = thestr.split(" v ")
        if len(info) == 2:
            #We have found a comparison header
            if not info[0] in alts:
                alts.append(info[0])
            if not info[1] in alts: 
                alts.append(info[1])
    print(alts)
    #offset = find_offset()
    #endrow = find_end_row()
    #im going to start with psuedo code
    return(None)


print("What?")
from_nish_excel("nish_data.xlsx")