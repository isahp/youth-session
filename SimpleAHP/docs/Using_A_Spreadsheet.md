# Using Spreadsheets For Data In SimpleAHP
The *SimpleAHP* web application can load data from a spreadsheet and present the results.  The spreadsheet can either be:
* An Excel **XLSX** file, or
* A google spreadsheet

No matter which of the two options you choose, the way data needs to be put into the the spreadsheet is identical.

## Spreadsheet structure
The rules for the spreadsheet structure are fairly straightforward

1. Each voter gets their own sheet within the spreadsheet, the name of the sheet is the name of the user
2. Demographic information is in a separate sheet called **info**
3. We accept several formats for the actual pairwise votes.
4. A few extra notes:
  1. Not all voters need to do a complete comparison set (in fact they all could do as little as a spanning set)
  2. The voters could even do *different* spanning sets
  3. We allow both Equals/Better/Much Better voting (EBB voting) and standard 1-9 scale voting
  4. You can mix EBB votes and 1-9 votes in the same spreadsheet
  5. You can even mix EBB and 1-9 votes in a single participant's sheet!

### Format of a single voter's sheet
The layout for the sheet of a single voter's values follows a three column format.

1. The first column is the name of the **First Alternative** being compared
2. The second column is the vote value
