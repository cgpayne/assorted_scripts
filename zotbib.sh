#!/bin/bash
##  zotbib.sh
##  By: Charlie Payne
##  Copyright (C): 2018
##  License: see LICENSE (GNU GPL v3)
## DESCRIPTION
##  this script will parse a BibTeX file (for instance, one from Zotero) into my preferred form
##  that is, in each bibtex entry we manipulate the author names, abbreviate the journal name, ...
##  ...and remove the following fields: issn, abstract, language, urldate, month, and file
## KNOWN BUGS / DESIRED FEATURES
##  [clear]
## OPTIONS
##  -u for "usage": see script usage
##  -h for "help": less the relevant documentation and see script usage
##  -m <phys|ow> for "mode": see namemanip.sh, it's the same option, where
##    'phys' = 'physics' (LFM -> FML) [default]
##    'ow'   = 'otherwise' (FML -> LFM)
##  -e <number|4> for "et al": if number(authors) > number(e), then we shorten to number(e) authors and append 'et al.'
## PARAMETERS
##  1) bibfile=${1}    # the BibTeX file to be parsed
## STAGES
##  stage 0 = the removal stage, where we take out undesired fields from the entries
##  stage 1 = the parsing stage, where we handle journal and author names in the entries
PURPLE=$(tput setaf 5)  # get the purple [5] text environment  (usage base)
RED=$(tput setaf 1)     # get the red [1] text environment     (usage error)
GREEN=$(tput setaf 2)   # get the green [2] text environment   (datatype identifier)
BOLD=$(tput bold)       # get the bold text environment        (default values)
UNDERLINE=$(tput smul)  # get the underline text environment   (variable names)
RESET=$(tput sgr0)      # don't forget to reset afterwards!
erro(){ echo "$@" 1>&2; }
myUsage(){ erro "${PURPLE}Usage (${RED}${1}${PURPLE}):${RESET} `basename ${0}` [-u for usage] [-h for help] [-m <${BOLD}phys${RESET}|ow>] [-e <${GREEN}number${RESET}|${BOLD}4${RESET}>] <${UNDERLINE}bibfile${RESET}>"; exit 1; }

somevalue='<insert>'    # <insert description, this is used below>
mysh=$MYSH    # this must point to where this current script lives
stdon='on'
stdoff='off'



# function prototype: <insert description>
somefunction1(){
  # <insert code>
  echo $output
}

# function prototype: <insert description>
somefunction2(){
  # <insert code>
  echo $output
}


# pre-parse the script parameters
if [ -z "${1}" ]
then
  erro 'ERROR 0: god is empty, just like me...'
  exit 1
fi
##### HERE ####
somearg=$stdoff # <insert description like: default value for -e, or: this gets turned on by option -e>
while getopts ":uhm:e:" myopt # filter the script options
do
  case "${myopt}" in
    u) # -u for "usage": see script usage
      myUsage;;
    h) # -h for "help": less the relevant documentation and see script usage
      sed -n '2,23p; 24q' $mysh/zotbib.sh | command less
      myUsage
      ;;
    e) # -e <on|off> for "example": <insert description>
      somearg=${OPTARG}
      if [ $somearg != $stdon ] && [ $somearg != $stdoff ]
      then
        myUsage 'option -e is out of bounds'
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
bibfile=${1}    # the BibTeX file to be parsed


# parse the input
if [ $firstparam != $somevalue ]
then
  firstparam="${firstparam}_${somevalue}"
fi


# pre-check
erro '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
erro "firstparam     = $firstparam"
erro "secondparam    = $secondparam"
erro '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
erro 'is this input acceptable? (Y/N)'
read incheck
erro
if [ $incheck = 'n' ] || [ $incheck = 'N' ]
then
  erro 'exiting...'
  exit 1
fi
if [[ ! $secondparam =~ ^[0-9]+$ ]] || [ $secondparam -eq 0 ]
then
  erro 'ERROR 1111: secondparam is not a positive integer!'
  erro "secondparam = $secondparam"
  erro 'exiting...'
  exit 1
fi



#----------------------------------- STAGE 0 -----------------------------------

# <insert code>



## FIN
