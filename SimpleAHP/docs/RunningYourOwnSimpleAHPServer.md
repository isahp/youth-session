# Running Your Own SimpleAHP Server
The SimpleAHP server is open source software, that can be freely downloaded and used.  It is written in the R programming language, making use of the Shiny R library for creating webapps. In order to have your own version of SimpleAHP running on your own server you need the following pieces of information

2. You need a server somewhere (you can get a free Amazon server for one year, we'll explain how below)
1. You need to download the source from [Our github repository](https://github.com/isahp/youth-session)
3. You need to install R and the Shiny-Server on your server (details below)
4. You need to put our source code for SimpleAHP on your server, in the correct directory
5. That is it!

**Note:** Our explanations of what to install, and where to install it are based upon using an Amazon server running Ubuntu 14.04.  The instructions would be very similar for other unix based servers.

## 1. Getting a free Amazon Web Services Server and Installing R

Luckily someone has already written an excellent guide to this process. So the steps we'll outline here are:

1. Get a free amazon aws account, if you do not already have one [create a free amazon aws account](https://aws.amazon.com/)
2. Read [Setting up an AWS instance for R, RStudio, OpenCPU, or Shiny Server](http://ipub.com/aws/), for details on how to create your server, and install R on it

## 2. Installing Shiny on your server

Again, luckily, someone has already written nice instructions on how to install Shiny on an aws server (which you created in the last step).  All you have to do is:

1. Follow the instructions at [Installing RStudio Shiny Server on AWS](http://www.r-bloggers.com/installing-rstudio-shiny-server-on-aws/)

## 3. Getting our source code on your server
Our source code is freely available via github, using the git version control system (see [Git Homepage](https://git-scm.com/) for more information on about git).  In order to get our source code to your server, do:

1. Ssh into your server
2. Install git on it, if it is not already installed.  Simple run the following command on your server.  If it tells you git is not installed, follow the instructions it gives to install it.

  ```
  git
  ```
3. Become root (I recommend `sudo su -`)
4. Change directory to where Shiny is serving apps from by executing the following:

  ```
  cd /srv/shiny-server
  ```
5. Get our source code by running the following command

  ```
  git clone https://github.com/isahp/youth-session.git
  ```
6. You will now have a directory called `youth-session` in the `/srv/shiny-server` directory.  The last thing to do is make a symbolic link from to the directory in `youth-session` that contains the app.  Do this by running the following command

  ```
  ln -s youth-session/SimpleAHP/PairwiseShinyApp SimpleAHP
  ```
7. Test the installation by point your web browser to

  ```
  http://YOUR_AWS_SERVER_ADDRESS/SimpleAHP
  ```

## 4. Getting Help
We have a discussion group setup on gitter to answer questions you all run into, or suggestions for improvements, etc.  It is available at:

* [https://gitter.im/isahp/youth-session](https://gitter.im/isahp/youth-session)

You can view the discussion group without logging in.  To post questions/ideas/etc you need to log in.  You can use either a twitter account, or github account.

* To create a free twitter account, go to [https://twitter.com/signup](https://twitter.com/signup)
* Or, to create a free github account, go to [create a free github account](https://github.com/join?source=header-home)
