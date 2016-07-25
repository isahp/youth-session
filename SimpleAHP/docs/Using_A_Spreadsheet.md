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

* **(<)** Means the first alternative is better.  Think of it like &#x2190; pointing towards the dominant choice.  For example

  | A        | B |   C     |
  |----------|---|---------|
  |Chocolate | < | Vanilla |  
  Is a vote of *Chocolate is better than Vanilla*
  
* **(<<)** Means the first alternative is much better.  Think of it like a double &#x2190;, pointing towards the dominant choice.

  | A        | B |   C     |
  |----------|---|---------|
  |Chocolate | << | Vanilla |  
  Is a vote of *Chocolate is* **much** *better than Vanilla*
  

* **(>)** Means the second alternative is better.  Think of it like &#x2192; pointing towards the dominant choice, for example

  | A        | B |   C     |
  |----------|---|---------|
  |Chocolate | > | Vanilla |  
  Is a vote of *Vanilla is better than Chocolate*

* **(>>)** Means the second alternative is much better.  Think of it like &#x2192; pointing towards the dominant choice, for example

  | A        | B |   C     |
  |----------|---|---------|
  |Chocolate | > | Vanilla |  
  Is a vote of *Vanilla is* **much** *better than Chocolate*

* **(NUMBER)** Any vote may be a simple number, in any of the following formats
  * A number 1,2,3,4,5,6,7,9
  * A decimal vote, e.g. 2.37168
  * A reciprocal vote, e.g. 1/8
  * An example follows

  | A   | B  |  C  |
  |-----|----|-----|
  |Chocolate| 8 |  Vanilla|
  |Chocolate | 1/3 | Strawberry|
  
  Are numerical votes meaning *Chocolate is 8 times better than Vanilla* and *Chocolate is 1/3 as good as Strawberry*, or in other words *Strawberry is 3 times better than Chocolate*
  
## 1.3 The demographic information
Demographic information should appear in a sheet called **info**.  It take the following form:
  * Each row is the full demographic information for a user.
  * The columns are the demographic information, the first column is the user naem
  * The user name **must** match the name of a sheet in the spreadsheet (the sheet for that user's votes)
  * The first row tells the names of the demographic columns (the A1 cell should be left blank)
  * The demographic information is treated as purely categorical (i.e. if the demographic was age, and people inputed 16, 25, 30, 33, 18, 19 you could not see 18-24 year olds ... to do that, you need to have an 18-24 option and have that as the value).
  * Below is an example demographic sheet

  |     |Age	|Gender	|Fav Color|
  |-----|----|-------|---------|
  |Bill |40-50 |M |blue|
  |Elena |20-30 |F |red|
  |Rozann |60+ |F |green|
  |Dan |40-50 | M |purple|
  |John |40-50| M |green|

## 2. Direct linking to immediately load a Google Spreadsheet

Although you can load a google spreadsheet directly from SimpleAHP, it is nice to have a single URL that will load your data and immediately present you with results.  This is how all of the links like http://tiny.cc/youthAHPOut1 have been made.

**WARNING:** This method does not work with the tiny.cc/SimpleAHP URL, you have to know the full URL for the SimpleAHP web server.  If you install your own SimpleAHP, this method *will* work on that server as well.

1. Go to your google spreadsheet and choose the File &#x2192; Publish to the web
2. Copy that URL, let's call the value of that URL **MY_SHEET_URL**
3. The url to load your sheet will be:  

  ```
  http://ec2-52-37-195-69.us-west-2.compute.amazonaws.com/pairwise-app/?gsheetUrl=MY_SHEET_URL
  ```
4. As an added bonus you can go to http://tiny.cc and create a tiny URL that points to your above address so it is easier to share with others!

## 3. Example spreadsheets
We have an example with and without demographic information.  They are available at:

* [Example XLSX file without demographics](https://github.com/isahp/youth-session/raw/master/QuestionnaireSimplified/ExampleExcel.xlsx)
* [Example XLSX file with demographics](https://github.com/isahp/youth-session/raw/master/QuestionnaireSimplified/ExampleWithDemographics.xlsx)
