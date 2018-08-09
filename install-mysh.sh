#!/bin/bash
##  install-mysh.sh
##  By: Charlie Payne
##  Copyright (C): 2018
##  License: see LICENSE (GNU GPL v3)
## DESCRIPTION
##  this will install all the shell scripts in this directory to $HOME/bin (by default) or the directory provided to ${1}
## PARAMETERS
##  1) instdir=${1}    # the desired installation directory
erro(){ echo "$@" 1>&2; }
myUsage(){ erro "Usage${1}: `basename ${0}` [-u for usage] <instdir|default>"; exit 1; }
instdir=${1}    # the desired installation directory (including the full path to it)
mysh=$MYSH    # this must be set to the path of this repository


# parse the input / pre-check
if [ -z ${1} ] || [ $instdir = 'default' ]
then
  instdir="$HOME/bin"
elif [ ${1} = '-u' ]
then
  myUsage
elif [ ${#} -ge 2 ] # check that the right number of script paramters have been filled
then
  myUsage ' (incorrect number of script parameters)'
fi
if ! [ -d $instdir ]
then
  erro 'ERROR 0691: instdir is not an existing directory!'
  erro "instdir = $instdir"
  erro 'exiting...'
  exit 1
fi
if [ ${instdir:0:1} = '.' ] || [ ${instdir:0:2} = '..' ]
then
  erro 'ERROR 4501: please enter an expanded form of the path, sorry!'
  erro "instdir = $instdir"
  erro 'exiting...'
  exit 1
fi


echo "installing MYSH to: $instdir..."
echo
for script in ${mysh}/*.sh
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
