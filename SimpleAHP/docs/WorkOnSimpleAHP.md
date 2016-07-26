# Quickstart Guide To Running SimpleAHP
This guide will help you do one or more of the following:

1. [Get the SimpleAHP source code on your computer](#1-getting-the-simpleahpsource-code)
2. [Install RStudio, the IDE (integrated development environment) we use to develop SimpleAHP (and to run it/test it)](2. Install RStudio](#2-install-rstudio)
2. [Run the SimpleAHP application through R](#3-run-the-simpleahp-app-through-rstudio)
3. [Begin editing the source code to SimpleAHP to make your own changes](#4-egin-editing-code)
5. [Getting Help](#5-getting-help)

## 1. Getting the SimpleAHP source code
There are three different ways to get the SimpleAHP source code:

1. The easiest is to simply download the zip of the source from github.
2. Is to use Github Desktop to get the source code.  With this method, a single button will allow you to update the source code the latest version (instead of having to re-download it).
3. Is to get a github login (before or after you've gotten the source code), and put the github login credentials into Github desktop.  You do this if you make changes and want to share them with the community by doing a simple button press.

### 1.1 Get the SimpleAHP source code (The simplest option)
For this option, the steps are very easy:

1. Go to https://github.com/isahp/youth-session
2. Click on the green *Clone or download* button in the upper right
3. Select `Download Zip` from the popup window
4. Extract the zip file

With this option you have immediate access to our source code.  If that is all you want to do, skip to
[Section 2](#2-install-rstudio).

### 1.2 Get the SimpleAHP through Github Desktop
If you wish to easily stay up to date with our latest code changes to SimpleAHP, you probably want to use Github Desktop to get access to the source code.  Our SimpleAHP source code is hosted in a `git` repository on github.  Git is a distributed version control system.  This means that the entire history of how our code has changed is available!  To install Github Desktop and get a copy of our code, do:

1. Go to https://desktop.github.com/ and Download the installer for your operating system.  Note: linux is not supported, but there are other git tools available for linux systems.
2. Install the app as usual for your operating system.
3. Go to  https://github.com/isahp/youth-session
4. Click the gree *Clone of download* button in the upper right
5. Select *Open in Github Desktop*
6. Github Desktop will open, follow the prompts to `clone' the repository (i.e. grab our source code)
 
### 1.3 Sharing your code changes
The great thing about hosting your code on github is that, not only can others easily access it, others can actually contribute changes back!  For example, if you see a bug, and fix it, you can easily share that code back to the community.  If you have Github Desktop installed already on your machine, you only need a free github account, give Github Desktop access to your github account, and create a pull request.  Just follow these steps:

1. Get a free github account at https://github.com/join
2. Allow Github Desktop to use your newly created github account, [here are directions](https://help.github.com/desktop/guides/getting-started/authenticating-to-github/)
3. Make your changes to the source code.
4. Commit the changes in Github desktop
5. Create a `Pull Request` by choosing *Repository &#x2192; Create Pull Request ...*


## 2. Install RStudio

In order to run, edit, test, or develop SimpleAHP on your computer you need to install the RStudio IDE, as well as the R programming language.

1. Install the R language:
  1. For windows, download and install from https://cran.r-project.org/bin/windows/base/
  2. For MacOSX, download and install from https://cran.r-project.org/bin/macosx/
  3. For Ubuntu 16.04, follow the instructions [here](https://www.datascienceriot.com/how-to-install-r-in-linux-ubuntu-16-04-xenial-xerus/kris/)
  4. For Ubuntu 14.04, follow [these instructions](http://www.r-bloggers.com/installing-rrstudio-on-ubuntu-14-04/)
2. Download RStudio from https://www.rstudio.com/products/rstudio/download/.  Choose the installer for your operating system.
3. Install RStudio as per usual for you operating system.

## 3. Run the SimpleAHP App Through RStudio
Once you have RStudio installed, to run the SimpleAHP app, simply:

1. In a File browser, go to the root directory you got from github.
2. In that directory is a SimpleAHP directory, and inside of that is a PairwiseShinyApp subdirectory, go there.
3. Double click on PairwiseShinyApp.Rproj in that directory.  It will launch RStudio, and load our application
4. In the console window (bottom left window), run the following commands  (to get all of the libraries we use)

  ```
  install.packages("plotly")
  install.packages("shinyBS")
  install.packages("openxlsx")
  install.packages("googlesheets")
  install.packages("gsheets")
  ```
5. In the lower right is a File browser, select the `ui.R` file, which will bring it up in the editor window
6. At the top of the editor window, on the right will be a *Run App* item, with a green triangle beside it, click that to run SimpleAHP

## 4. Begin Editing Code

The source code is all in the `SimpleAHP/PairwiseShinyApp` directory of the source code you got in [Step 1]((#1-getting-the-simpleahpsource-code).  The source files all end in `.R`.  The files are:

* **server.R**: Any Shiny web app needs to have one of these, it is the code that handles the server side interaction.
* **ui.R**: Again, this is a standard Shiny file.  This file creates the web user interface.
* **basics.R**: This file has the code for handling symbolic voting, getting the votes, etc.  It also has the code that is called when the definition of Better or Much Better is changed.  It 
* **common-fxs.R**: This file has eigenvector and priority calculation functions in it.  In addition it has our new experimental ideas for priority vector calculations.
* **set-globals.R**: This contains the functions that set the global variables which store all pairwise comparison matrices, their actual numerical versions, and calculated priorities.
* **parse-google.R**: The code specifically to parse google spreadsheets, and spreadsheets tied to google forms is here.

## 5. Getting help

We have gitter.im discussion room at https://gitter.im/isahp/youth-session .  You can view the room without logging in.  However if you wish to ask a question, you need to click on the *Sign in to start talking* button at the bottom of the screen.  You can sign in with either a twitter account, or a github account.  If you do not have either account, I would recommend getting a free github account by going to https://github.com/join, since you can use that same account to contribute any changes you eventually make back to the community.

