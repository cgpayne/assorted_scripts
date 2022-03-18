#!/bin/bash
##  scalws.sh
##  By: Charlie Payne
##  Copyright (C): 2021
##  License: see LICENSE (GNU GPL v3)
## DESCRIPTION
##  scalws = scale leading whitespaces
##  this script will expand/contract the leading whitespace of each line in a file by a factor ${2}/${1}
## KNOWN BUGS / DESIRED FEATURES
##  -- confident for expanding whitespace, not confident about behaviour when contracting whitespace
##  -- not sure if can be inverted (really tired right now); eg, does scalws B A file.txt necessarily undo scalws A B file.txt ?
##  -- add flag: represses the file backup
##  -- add flag: represses output to screen
## PARAMETERS
##  1) initialL=${1}    # length of initial string of leading whitespaces
##  2) finalL=${2}      # length of final string of leading whitespaces
##  3) filename=${3}    # the file to alter
PURPLE=$(tput setaf 5)  # get the purple [5] text environment  (usage base)
RED=$(tput setaf 1)     # get the red [1] text environment     (usage error)
GREEN=$(tput setaf 2)   # get the green [2] text environment   (datatype identifier)
BOLD=$(tput bold)       # get the bold text environment        (default values)
UNDERLINE=$(tput smul)  # get the underline text environment   (variable names)
RESET=$(tput sgr0)      # don't forget to reset afterwards!
erro(){ echo "$@" 1>&2; }
myUsage(){ erro "${PURPLE}Usage (${RED}${1}${PURPLE}):${RESET} `basename ${0}` [-u for usage] <${UNDERLINE}initialL${RESET}> <${UNDERLINE}finalL${RESET}> <${UNDERLINE}filename${RESET}>"; exit 1; }
initialL=${1}    # length of initial string of leading whitespaces
finalL=${2}      # length of final string of leading whitespaces
filename=${3}    # the file to alter
# somevalue='<insert>'    # <insert description, this is used below>
# stdon='on'
# stdoff='off'


# parse the input / pre-check
if [ -z "${1}" ]
then
  erro 'ERROR 0: god is empty, just like me...'
  exit 1
elif [ "${1}" = '-u' ]
then
  myUsage
elif [ ${1:0:1} = '-' ] && [[ ${1:1:2} =~ [a-zA-Z] ]]  # NOTE: should probs put this in all scripts!
then
  myUsage "option -${1:1} not recognized"
elif [ ${#} -ne 3 ] # check that the right number of script paramters have been filled
then
  myUsage 'incorrect number of script parameters'
fi
if [[ ! $initialL =~ ^[0-9]+$ ]] || [ $initialL -eq 0 ]
then
  erro 'ERROR 081: initialL is not a positive integer!'
  erro "initialL = $initialL"
  erro 'exiting...'
  exit 1
fi
if [[ ! $finalL =~ ^[0-9]+$ ]] || [ $finalL -eq 0 ]
then
  erro 'ERROR 082: finalL is not a positive integer!'
  erro "finalL = $finalL"
  erro 'exiting...'
  exit 1
fi
if [ ! -f $filename ]
then
  erro 'ERROR 5000: filename is not a file in this directory!'
  erro "filename = $filename"
  erro 'exiting...'
  exit 1
fi


# make backup file
#if []
#then
cp $filename $filename.sbu
#fi

# loop through lines of file and scale the leading whitespace
filelen=$(wc -l < $filename)
for ((i=1; i<=$filelen; i++))
do
  withspaces=`sed -n ${i}p $filename`
  nospaces=$(echo "$withspaces" | sed 's/^ *//')  # set leading whitespace to zero
  splen=$((${#withspaces}-${#nospaces}))
  if [ $splen -ne 0 ]
  then
    newlen=$((${splen}*${finalL}/${initialL}))
    #if []
    #then
    echo "${i}: ${splen} -> ${newlen}"
    #fi
    newws=$(printf "%${newlen}s")  # a string of whitespaces that is $newlen long
    sed -i'.bak' "${i}s/^ */${newws}/" $filename; rm -f $filename.bak
  fi
done


## FIN
