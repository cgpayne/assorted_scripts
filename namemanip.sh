#!/bin/bash
##  namemanip.sh
##  By: Charlie Payne
##  Copyright (C): 2018
##  License: see LICENSE (GNU GPL v3)
## DESCRIPTION
##  this script will manipulate a name into the deisred form, which the user must specify a priori!
##    either (default):  'Last, First M.' (LFM) -> 'F. M. Last' (FML)
##    ...or:             'First M. Last' (FML) -> 'Last, F. M.' (LFM)
##  NOTE: you can provide either the expanded first name(s) or initial(s), both will work...
##        ...and we will space out initials such that 'F.M.' -> 'F. M.'
## OPTIONS
##  -u for "usage": see script usage
##  -h for "help": less the relevant documentation and see script usage
##  -m <phys|ow> for "mode": this sets the direction of the name switch, where
##    'phys' = 'physics' (LFM -> FML) [default]
##    'ow'   = 'otherwise' (FML -> LFM)
## PARAMETERS
##  1) thename=${1}     # someone's name, in either LFM or FML (depending on the chosen option/mode)
PURPLE=$(tput setaf 5)  # get the purple [5] text environment  (usage base)
RED=$(tput setaf 1)     # get the red [1] text environment     (usage error)
BOLD=$(tput bold)       # get the bold text environment        (default values)
UNDERLINE=$(tput smul)  # get the underline text environment   (variable names)
RESET=$(tput sgr0)      # don't forget to reset afterwards!
erro(){ echo "$@" 1>&2; }
myUsage(){ erro "${PURPLE}Usage (${RED}${1}${PURPLE}):${RESET} `basename ${0}` [-u for usage] [-h for help] [-m <${BOLD}phys${RESET}|ow>] \"${UNDERLINE}nameLFM${RESET}\""; exit 1; }
physics='phys'    # this default option makes the switch:  LFM -> FML
otherwise='ow'    # this option does the inverse switch:   FML -> LFM
mysh=$MYSH    # this must point to where this current script lives



# function prototype: shortens a name to it's initial, like 'Name' -> 'N.'
shortener(){
  local longname=${1}
  local lastlast=`echo -n $longname | tail -c 1`
  if [ ${#longname} -eq 1 ] # nobody has a single letter name..?
  then
    shortname="${longname}."
  elif [ $lastlast != '.' ] # it could already be in shortened form
  then
    shortname="${longname:0:1}."
  else
    shortname=$longname
  fi
  echo $shortname
}

# function prototype: this makes sure there's spaces between initials, like 'F.M.' -> 'F. M.'
splitter(){
  local somestring="$@"
  echo `echo "$somestring" | sed 's/\./\. /g'`
}

# function prototype: makes initials out of multiple names
initials(){
  local MANYNAMES=($@) # do not put double-quotes around the $@ here!
  local length=${#MANYNAMES[@]}
  local INITIALS=()
  for ((i=0; i<$length; i++))
  do
    INITIALS+=(`shortener ${MANYNAMES[$i]}`)
  done
  echo "${INITIALS[@]}"
}


# pre-parse the script parameters
if [ -z "${1}" ]
then
  erro 'ERROR 0: god is empty, just like me...'
  exit 1
fi
themode=$physics # default value for -m
while getopts ":uhm:" myopt # filter the script options
do
  case "${myopt}" in
    u) # -u for "usage": see script usage
      myUsage;;
    h) # -h for "help": less the relevant documentation and see script usage
      sed -n '2,19p; 20q' $mysh/namemanip.sh | command less
      myUsage
      ;;
    m) # -m <phys|ow> for "mode": this sets the direction of the name switch
      themode=${OPTARG}
      if [ $themode != $physics ] && [ $themode != $otherwise ]
      then
        myUsage 'option -m is out of bounds'
      fi
      ;;
    \?)
      myUsage "option -${OPTARG} not recognized";;
  esac
done
shift $(($OPTIND-1))
if [ ${#} -ne 1 ] # check that the right number of script paramters have been filled
then
  myUsage 'incorrect number of script parameters'
fi
thename=${1}     # someone's name, in either LFM or FML (depending on the chosen option)



# physics: LFM -> FML
if [ $themode = $physics ]
then
  lastname=${thename%,*}
  firstnames=${thename#*,}
  firstnames=$(splitter "$firstnames")
  firstnames=$(initials "$firstnames")
  thename="$firstnames $lastname"
fi


# otherwise: FML -> LFM
if [ $themode = $otherwise ]
then
  lastname=${thename##* }
  firstnames=${thename% ${lastname}}
  firstnames=$(splitter "$firstnames")
  firstnames=$(initials "$firstnames")
  thename="${lastname}, $firstnames"
fi


# output
echo $thename



## FIN
