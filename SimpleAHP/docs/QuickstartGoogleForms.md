# Quickstart Guide Using Google Forms with SimpleAHP

Welcome, if you are here then either you are considering participation in the Youth
Session at ISAHP 2016 in London <a href="http://isahp.org">http://isahp.org</a>, or
you are interested in using the tool Dr. Adams wrote to get pairwise information
from google forms and produce individual, group, and subgroup priorities.
In either case you can see an example of the results of using this process at
<a href="http://bit.ly/music-choice-example-results">Music Preference Example</a>.

**NOTE:** If you want to use a paper questionnaire and fill out a google / Excel spreadsheet instead, please see [Using A Spreadsheet](Using_A_Spreadsheet.md)

<h3><a id="outline" class="anchor" href="#outline" aria-hidden="true">
<span aria-hidden="true" class="octicon octicon-link"></span></a>
Outline of Quickstart Document
</h3>
This document consists of the following sections:
<ol>
  <li><a href="#1-background">Background</a>
  <li><a href="#2-how-to-pick-an-interesting-problem">How to pick an interesting problem.</a>
  <li><a href="#3-how-to-choose-alternatives">How to choose alternatives.</a>
  <li><a href="#4-getting-started-with-google-forms">Getting started with Google Forms.</a>
  <li><a href="#5-create-the-google-form-questionnaire">Create the Google Form Questionnaire.</a>
  <li><a href="#6-configuring-the-google-form">Configuring the Google Form.</a>
  <li><a href="#7-configuring-the-google-spreadsheet-of-responses">Configuring the Google Spreadsheet of Responses.</a>
  <li><a href="#8-seeing-the-results">Seeing the results.</a>
  <li><a href="#9-getting-help">Getting Help</a>
</ol>


### 1. Background ##
AHP is a multicriterion decision method developed by Dr. Saaty in the 1970's.
It has several pieces to it, including a method of breaking down complex
decisions into simpler elements, the decision hierarchy.  In addition there
is a method for understanding how important various pieces of the decision
are, called the pairwise comparison method.  A brief introduction to AHP
theory can be found at <a href="https://mi.boku.ac.at/ahp/ahptutorial.pdf">AHP
Tutorial</a>, and pages 7-10 of that document discuss pairwise comparisons.
<p>
This tool only covers the pairwise comparison part of AHP theory.  However,
this tool can be used to do multiple voter pairwise comparisons in an
elegant and very visual method.

### 2. How To Pick An Interesting Problem
Pairwise comparisons are used to find an individual's or group's opinion on
a particular set of alternatives.  Pairwise comparisons not only let us find out
an individual, or group's preferences, but how strong those preferences are.
<p>
<u>Example:</u> We want to know folks preferences for types of music.  For
instance, in a classroom we are going to allow music to be played during
lunch time.  We have 4 play lists to choose from, Rock, Country, Pop, and
Classical.  We would like to play the music that most people want to hear,
taking into consideration if folks really like or hate a particular type.
<p>
  Pairwise comparisons is a perfect method for solving this problem.  We
  would ask our students to answer the following questions:
  <ul>
    <li> Which is better, Rock or Country, and by how much on a scale of 2-9?
    <li> Which is better, Country or Pop, and by how much on a scale of 2-9?
    <li> Which is better, Pop or Classical, and by how much on a scale of 2-9?
    <li> Which is better, Rock or Pop, and by how much on a scale of 2-9?
    <li> Which is better, Country or Classical, and by how much on a scale of 2-9?
    <li> Which is better, Rock or Classical, and by how much on a scale of 2-9?
  </ul>
  The AHP pairwise process allows us to take that data and turn it into overall
  preferences for individuals and the group for each of these types of music.
  Whichever music type is preferred by the group is the one we should generally
  play.
  <p>
  <u>Picking a good problem:</u>  A good problem for this pairwise process should
  follow these general rules.
  <ol>
    <li> We have a group of alternatives that we want to know the group's preference of.
      For example, the music types mentioned above.
    <li> Make the alternatives you are choosing between interesting to your participants.
      For instance, choosing a favorite programming language would not be interesting
      to a general audience, but would be interesting to computer tech folks.
    <li> There should be at least 3 alternatives we are choosing between (to make it interesting)
      and there should generally be 7 or less alternatives.  Note: if you have 7 alternatives
      there will be 21 questions, which is quite a lot.  However if you truly
      have a lot of choices, you can ask less questions and still get good results.
    <li> Include demographic data about your participants.  With that demographic
      data, e.g. age, favorite color, gender, etc, you can look at the differences
      and similarities between group opinions.  For instance, perhaps girls prefer
      Rock music and boys prefer Classical in your group.
  </ol>
### 3. How to choose alternatives

Once we have the question formulated, and a preliminary set of alternative, i.e.
a set of things we want to know folks preferences about, try to follow these
rules for your alternative names.
<ol>
  <li>The alternative names should be short, but informative.
  <li>If you have more than 7 alternatives, consider coalescing your alternatives
    down to a smaller grouping.  In our music example, we may have started off
    with Punk Rock, Alternative, Metal, and Progressive Rock, all as options.
    We could coalesce those into a single "Rock" option.
  <li> Alternately if you have 7 or more alternatives, and you feel you must
    keep them all, you should probably not pairwise compare every alternative
    to every other alternative.  For 7 alternatives that is 21 questions, for
    8 alternatives it is 28 questions, 9 alternatives it is 36, etc.  Your audience will most likely
    get bored and annoyed by answering all of those questions.  Instead you
    can choose a limited selection of pairwise comparisons to perform and still
    arrive at valid results.
</ol>

### 4. Getting started with Google Forms

In order to use google forms to make a questionnaire, you <u>must</u> have
a google account.  If you do not already have one, you can create one
by following this link <a href="https://accounts.google.com/signup">Google
Account Signup</a>.  Once you have your account, you can get started with
google forms by going to <a href="https://forms.google.com">forms.google.com</a>
Several quick start guides to google forms can be found, some of which are:
<ul>
  <li><a href="https://support.google.com/docs/answer/87809?hl=en">Google help for forms</a>
  <li><a href="https://www.youtube.com/watch?v=IPv9CPSxsSc">Youtube intro to google forms 2016</a>
  <li><a href="https://www.uaa.alaska.edu/studentaffairs/advancingstaffexcellence/upload/Google-Form-Tutorial.pdf">
    Quick Intro To Google Forms via University of Alaska</a>
</ul>

### 5. Create the google form questionnaire

Your google form should have two types of questions: <u>Demographic</u> and
<u>Pairwise</u>, plus a question for the name of the participant.  Demographic
questions are simply questions that give you information about the respondent.
The Pairwise questions are the ones which ask which alternative is better
and by how much.  Both types of questions should follow a very straightforward
format.
<ul>
  <li><u>The name question:</u> That question can be anywhere in the questionnaire.
    But the text of that question must be <u>Name</u> spelled and capitalized
    exactly that way.
  <li><u>Demographic Questions:</u> They can be multiple choice, or fill in the
    blank, but must not contain the word <u>versus</u> in the question.  That
    is the only rule.  Any question that does not contain the word <u>versus</u>
    is automatically considered a demographic question.
  <li><u>Pairwise Questions:</u> These questions must always be of the form
    <u>Alternative 1 versus Alternative 2</u>.  In other words an alternative
    name, the word <u>versus</u> (spelled exactly that way, but captialization
    does not matter) and then another alternative name.  The question can have
    Hint Text that more fully describes the question, but the question text
    itself must have the A versus B form.  In addition the question must be
    either Multiple Choice, or "Drop down", with the following options:
    <ol>
      <li> They are equal
      <li> Alternative 1 is better
      <li> Alternative 1 is much better
      <li> Alternative 2 is better
      <li> Alternative 2 is much better
    </ol>
  <li><u>Notes on the pairwise questions response section</u>
    <ul>
      <li> The order does not make a difference (equal could come at the end for instance).
      <li> Alternative 1 and Alternative 2 must be spelled and captialized exactly as in the question text.
      <li> The words "better" and "much better" must appear spelled exactly.
      <li> The equals option is keyed in on the word "equal" in that option so you could add other items.
      <li> Because "equal" is a keyword used, please do not use an alternative with the
        word "equal" in its name!
    </ul>
</ul>

### 6. Configuring the Google Form 

Once you have completed the previous step, you can immediately begin to
solicit responses from your participants.  However, in order to use those
responses, we need to configure your google form to export the results
to a google spreadsheet.  To do this:
<ol>
  <li> Click on the "Responses Tab" at the top of the google form editor.
  <li> Click the "..." item in the upper right of the "Responses Tab" area and
    choose the "Select Response Destination"
  <li> Choose "Create a new spreadsheet" and give it an informative name.
</ol>
That is it!  Next we need to configure that spreadsheet, so that we can
access it to do calculations.

### 7. Configuring the Google Spreadsheet of Responses 

In the previous step, you told your google form to output the results to
a google spreadsheet.  Next we need to configure that spreadsheet to be readable
by the pairwise comparison web app.
<ol>
  <li>Go to <a href="http://spreadsheets.google.com">spreadsheets.google.com</a>.
  <li>Select the newly created spreadsheet.
  <li>Click the "Share" button in the upper right corner.
  <li>Click "Get shareable link" in the upper right corner of the popup and click Done on the popup.
  <li>Then choose the "File" menu, "Publish to the web"
  <li>In the popup leave everything as is, and simply click the publish button.
  <li>Copy the link from that popup, as it is needed for the next step.
</ol>

### 8. Seeing the results

To see the results, use the link to the published google spreadsheet you got
from the last step.  The steps are:
<ol>
  <li> Go to <a href="http://bit.ly/isahp2016-youth-app">bit.ly/isahp2016-youth-app</a>
  <li> On the upper left, choose the "Survey" tab.
  <li> This will show an input to put the link to the google spreadsheet in.
  <li> Paste the link to your spreadsheet, and click the "Update" button.
  <li> Now the UI should show you the results, by individual, group, etc.
</ol>
You can also send the URL to the google spreadsheet directly by doing the following.
<ol>
  <li>Point your browser at: http://http://ec2-52-37-195-69.us-west-2.compute.amazonaws.com/pairwise-app/?gformurl=YOUR_GSPREADSHEET_URL_GOES_HERE
  <li>Go to a link shortener (<a href="http://bit.ly">bit.ly</a> for example) and
    paste the above url into it, to get a more reasonable url.  I did this for my
    music choice example, and that link is available by
    <a href="http://bit.ly/music-choice-example-results">bit.ly/music-choice-example-results</a>
    which is a much nicer URL.
</ol>

### 9. Getting help

There are several methods available for getting help:
<ul>
  <li>Email questions to <a href="mailto://youth@isahp.org">youth@isahp.org</a>
  <li>There is a <a href="https://groups.google.com/forum/#!forum/isahp2016youth">
    google group for isahp2016 youth</a> and this project is a part of that effort.
    Feel free to post questions there.
  <li>The source code for this project is available on <a href="https://github.com/wjladams/youth-isahp">
    github here</a>.  You can submit bugs at the <a href="https://github.com/wjladams/youth-isahp/issues">
      github bug submission page for the project</a>.
</ul>
[Header Time](#helpme)
