#!/bin/bash
##  scriptinit.sh
##  By: Charlie Payne
##  Copyright (C): 2018
##  License: see LICENSE (GNU GPL v3)
## DESCRIPTION
##  this script will initialize a template for a script
##  I love Godelian loops!
## KNOWN BUGS / DESIRED FEATURES
##  -- must fix the containment problem, i.e. make this script contain the *.txt files we copy from
## OPTIONS
##  -u for "usage": see script usage
##  -h for "help": less the relevant documentation and see script usage
##  -l <1|2|3> for "level": sets the template level, where
##    '1' = 'basic' (only DESCRIPTION and PARAMETERS + myUsage example) [default]
##    '2' = 'intermediate' (DESCRIPTION, PARAMETERS + myUsage example, and some standard sections)
##    '3' = 'full' (DESCRIPTION, OPTIONS + myUsage example, PARAMETERS, pre-parsing example, and standard sections)
## PARAMETERS
##  1) scriptname=${1}    # the name of the script to be templated upon - don't forget the .sh extension!
##  2) copyyear=${2}      # (most likely) the current year (for the copyright)
PURPLE=$(tput setaf 5)  # get the purple [5] text environment  (usage base)
RED=$(tput setaf 1)     # get the red [1] text environment     (usage error)
BOLD=$(tput bold)       # get the bold text environment        (default values)
UNDERLINE=$(tput smul)  # get the underline text environment   (variable names)
RESET=$(tput sgr0)      # don't forget to reset afterwards!
erro(){ echo "$@" 1>&2; }
myUsage(){ erro "${PURPLE}Usage (${RED}${1}${PURPLE}):${RESET} `basename ${0}` [-u for usage] [-h for help] [-l <${BOLD}1${RESET}|2|3>] <${UNDERLINE}scriptname${RESET}> <${UNDERLINE}copyyear${RESET}>"; exit 1; }
mysh=$MYSH    # this must point to where this current script lives, along with the scriptinit_*.txt files
myname='Charlie Payne'     # this is my name, le derp!
thescript='<thescript>'    # we'll replace this string (in scriptinit_*.sh) with $scriptname (in $scriptname)
thename='<thename>'        # " " " " " " " " $myname " "
theyear='<theyear>'        # " " " " " " " " $copyyear " "
lev1='1'
lev2='2'
lev3='3'



# pre-parse the script parameters
if [ -z "${1}" ]
then
  erro 'ERROR 0: god is empty, just like me...'
  exit 1
fi
shlevel=$lev1 # default value for -l
while getopts ":uhl:" myopt # filter the script options
do
  case "${myopt}" in
    u) # -u for "usage": see script usage
      myUsage;;
    h) # -h for "help": less the relevant documentation and see script usage
      sed -n '2,20p; 21q' $mysh/scriptinit.sh | command less
      myUsage
      ;;
    l) # -l <1|2|3> for "level": sets the template level
      shlevel=${OPTARG}
      if [ $shlevel != $lev1 ] && [ $shlevel != $lev2 ] && [ $shlevel != $lev3 ]
      then
        myUsage 'option -l is out of bounds'
      fi
      ;;
    \?)
      myUsage "option -${OPTARG} not recognized";;
  esac
done
shift $(($OPTIND-1))
if [ ${#} -ne 2 ] # check that the right number of script paramters have been filled
then
  myUsage 'incorrect number of script parameters'
fi
scriptname=${1}    # the name of the script to be templated upon - don't forget the .sh extension
copyyear=${2}      # (most likely) the current year (for the copyright)


# pre-check
if [[ ! $copyyear =~ ^[0-9]+$ ]] || [ $copyyear -eq 0 ]
then
  erro 'ERROR 1111: copyyear is not a positive integer!'
  erro "copyyear = $copyyear"
  erro 'exiting...'
  exit 1
fi
if [ -s $scriptname ]
then
  erro "ERROR 6001: $scriptname is already a script!"
  erro 'exiting...'
  exit 1
fi
scriptext=${scriptname##*.}
if [ $scriptext = $scriptname ]
then
  erro "ERROR 4050: it appears you've forgot to include the file extension!"
  erro "scriptname = $scriptname"
  erro "scriptext  = $scriptext"
  erro 'exiting...'
  exit 1
fi
if [ $scriptext != 'sh' ]
then
  erro "ERROR 0811: hey now, we're only programming in bash here!"
  erro "scriptname = $scriptname"
  erro "scriptext  = $scriptext"
  erro 'exiting...'
  exit 1
fi



# copy the specified template, replace the relevant strings, and remove the backup files (*.bak, necessary for execution on Mac OS X)

cp $mysh/scriptinit_${shlevel}.txt $scriptname
sed -i'.bak' "s/${thescript}/${scriptname}/g" $scriptname; rm -f $scriptname.bak
sed -i'.bak' "s/${thename}/${myname}/g" $scriptname; rm -f $scriptname.bak
sed -i'.bak' "s/${theyear}/${copyyear}/g" $scriptname; rm -f $scriptname.bak
chmod 755 $scriptname



## FIN
