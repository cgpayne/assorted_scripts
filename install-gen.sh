#!/bin/bash
##  install-gen.sh
##  By: Charlie Payne
##  Copyright (C): 2022
##  License: see LICENSE (GNU GPL v3)
## DESCRIPTION
##  a generalized version of install-mysh.sh
##  this will install all the shell scripts in ${1} to $HOME/bin (by default) or the directory provided to ${2}
##  an installation is only necessary when new scripts have been added, and/or script names have changed, etc
## KNOWN BUGS / DESIRED FEATURES
##  [clear]
## PARAMETERS
##  1) scrdir=${1}   # the directory where all the shell scripts live
##  2) instdir=${2}  # the desired installation directory
PURPLE=$(tput setaf 5)  # get the purple [5] text environment  (usage base)
RED=$(tput setaf 1)     # get the red [1] text environment     (usage error)
GREEN=$(tput setaf 2)   # get the green [2] text environment   (datatype identifier)
BOLD=$(tput bold)       # get the bold text environment        (default values)
UNDERLINE=$(tput smul)  # get the underline text environment   (variable names)
RESET=$(tput sgr0)      # don't forget to reset afterwards!
erro(){ echo "$@" 1>&2; }
myUsage(){ erro "${PURPLE}Usage (${RED}${1}${PURPLE}):${RESET} `basename ${0}` [-u for usage] <${UNDERLINE}scrdir${RESET}> <${UNDERLINE}instdir${RESET}|${BOLD}stdbin${RESET}>"; exit 1; }
scrdir=${1}   # the directory where all the shell scripts live
instdir=${2}  # the desired installation directory (including the full path to it)


# parse the input / pre-check
if [ -z "${2}" ] || [ $instdir = 'stdbin' ]
then
  instdir="$HOME/bin"
elif [ "${1}" = '-u' ]
then
  myUsage
elif [ ${1:0:1} = '-' ]
then
  myUsage "option -${1:1} not recognized"
elif [ ${#} -ge 2 ] # check that the right number of script paramters have been filled
then
  myUsage 'incorrect number of script parameters'
fi
if [ ! -d $instdir ]
then
  erro 'ERROR 0691: instdir is not an existing directory!'
  erro "instdir = $instdir"
  erro 'exiting...'
  exit 1
fi
if [ ${instdir:0:1} = '.' ] || [ ${instdir:0:2} = '..' ]
then
  erro 'ERROR 4501: please enter an expanded form of the path, sorry mang!'
  erro "instdir = $instdir"
  erro 'exiting...'
  exit 1
fi


echo "installing $scrdir to: $instdir ..."
echo
for script in ${scrdir}/*.sh
do
  scriptexec=$(basename $script)
  scriptexec=${scriptexec%.sh}
  ln -sfv $script ${instdir}/$scriptexec
done
echo
echo '...finished installing!'
echo
echo 'make sure you add the following line to your .bashrc file:'
echo "  export PATH=${instdir}:\$PATH"
echo


## FIN
