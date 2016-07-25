# Using Spreadsheets For Data In SimpleAHP
The *SimpleAHP* web application can load data from a spreadsheet and present the results.  The spreadsheet can either be:
* An Excel **XLSX** file, or
* A google spreadsheet

No matter which of the two options you choose, the way data needs to be put into the the spreadsheet is identical.

## 1. Spreadsheet structure
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

### 1.1 Format of a single voter's sheet
The layout for the sheet of a single voter's values follows a three column format.

1. The first column is the name of the **First Alternative** being compared
2. The second column is the vote value (see [Legal pairwise vote values](#legal-pairwise-vote-values) for details)
3. The third column is the name of the **Second Alternative** being compared.

In other words the structure of a row is like a sentence ``A *is much better* than B''

### 1.2 Legal pairwise vote values
The following are legal values for the second column (the vote value column)

* **<** Means the first alternative is better.  Think of it like &#x2190; pointing towards the dominant choice.  For example

  | A        | B |   C     |
  |----------|---|---------|
  |Chocolate | < | Vanilla |  
  Is a vote of *Chocolate is better than Vanilla*
  
* **<<** Means the first alternative is much better.  Think of it like a double &#x2190;, pointing towards the dominant choice.

  | A        | B |   C     |
  |----------|---|---------|
  |Chocolate | << | Vanilla |  
  Is a vote of *Chocolate is* **much** *better than Vanilla*
  

* **>** Means the second
