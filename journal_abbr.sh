#!/bin/bash
##  journal_abbr.sh
##  By: Charlie Payne
##  Copyright (C): 2018
##  License: see LICENSE (GNU GPL v3)
## DESCRIPTION
##  this will take a journal name and output it in its ISO 4 shortened version
##  it makes use of iso4.sh, so make sure that sucker is up to date
## KNOWN BUGS / DESIRED FEATURES
##  [clear]
## PARAMETERS
##  1) journal=${1}    # the journal name
PURPLE=$(tput setaf 5)  # get the purple [5] text environment  (usage base)
RED=$(tput setaf 1)     # get the red [1] text environment     (usage error)
BOLD=$(tput bold)       # get the bold text environment        (default values)
UNDERLINE=$(tput smul)  # get the underline text environment   (variable names)
RESET=$(tput sgr0)      # don't forget to reset afterwards!
erro(){ echo "$@" 1>&2; }
myUsage(){ erro "${PURPLE}Usage (${RED}${1}${PURPLE}):${RESET} `basename ${0}` [-u for usage] \"${UNDERLINE}journal${RESET}\""; exit 1; }
journal=${1}    # the journal name


# parse the input / pre-check
if [ -z "${1}" ]
then
  erro 'ERROR 0: god is empty, just like me...'
  exit 1
elif [ "${1}" = '-u' ]
then
  myUsage
elif [ ${1:0:1} = '-' ]
then
  myUsage "option -${1:1} not recognized"
elif [ ${#} -ne 1 ] # check that the right number of script paramters have been filled
then
  myUsage 'incorrect number of script parameters'
fi


# parse the name and output it in ISO 4
NAME=($journal)
NAMElength=${#NAME[*]}
ISO=() # initialize empty array, will become the final output
for ((i=0; i<NAMElength; i++))
do
  word=${NAME[${i}]}
  shorty=$(iso4 $word)
  ISO+=($shorty)
done
echo ${ISO[*]}


## FIN
