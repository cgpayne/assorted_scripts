#!/bin/bash
##  iso4.sh
##  By: Charlie Payne
##  Copyright (C): 2018
##  License: see LICENSE (GNU GPL v3)
## DESCRIPTION
##  this will take in a word and output its ISO 4 shortened version
##  I will add in more ISO 4 words as I need them (i.e., this is an incomplete dictionary)
##  if the word is not found, then the script will just output the input
## PARAMETERS
##  1) theword=${1}     # a single word
PURPLE=$(tput setaf 5)  # get the purple [5] text environment  (usage base)
RED=$(tput setaf 1)     # get the red [1] text environment     (usage error)
BOLD=$(tput bold)       # get the bold text environment        (default values)
UNDERLINE=$(tput smul)  # get the underline text environment   (variable names)
RESET=$(tput sgr0)      # don't forget to reset afterwards!
erro(){ echo "$@" 1>&2; }
myUsage(){ erro "${PURPLE}Usage (${RED}${1}${PURPLE}):${RESET} `basename ${0}` [-u for usage] <${UNDERLINE}theword${RESET}>"; exit 1; }
theword=${1}     # a single word


# parse the input / pre-check
if [ -z ${1} ]
then
  erro 'ERROR 0: god is empty, just like me...'
  exit 1
elif [ ${1} = '-u' ]
then
  myUsage
elif [ ${1:0:1} = '-' ]
then
  myUsage " (option -${1:1} not recognized)"
elif [ ${#} -ne 1 ] # check that the right number of script paramters have been filled
then
  myUsage 'incorrect number of script parameters'
fi


# dictionary
if [ $theword = 'Physics' ]
then
  theword='Phys.'
fi

# output
echo $theword


## FIN
