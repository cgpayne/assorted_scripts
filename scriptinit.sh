#!/bin/bash
##  scriptinit.sh
##  By: Charlie Payne
##  Copyright (C): 2018
##  License: see LICENSE (GNU GPL v3)
## DESCRIPTION
##  this script will initialize a template for a script
##  I love Godelian loops!
## OPTIONS
##  -u for "usage": see script usage
##  -h for "help": less the relevant documentation and see script usage
##  -l <1|2|3> for "level": sets the template level, where
##    '1' = 'basic' (only DESCRIPTION and PARAMETERS + basic Usage example)
##    '2' = 'intermediate' (DESCRIPTION, PARAMETERS, and some standard sections + basic Usage example)
##    '3' = 'full' (DESCRIPTION, OPTIONS + myUsage example, PARAMETERS, pre-parsing example, and standard sections)
## PARAMETERS
##  1) scriptname=${1}    # the name of the script to be templated upon
##  2) copyyear=${2}      # (most likely) the current year (for the copyright)
myUsage(){ echo "Usage ${1}: `basename ${0}` [-u for usage] [-h for help] [-l <1|2|3>] <scriptname> <copyyear>" 1>&2; exit 1; }
mysh=$MYSH    # this must point to where this current script lives, along with the scriptinit_*.txt files
myname='Charlie Payne'
thescript='<thescript>'
thename='<thename>'
theyear='<theyear>'
lev1='1'
lev2='2'
lev3='3'



# pre-parse the script parameters
while getopts ":uhl:" myopt # filter the script options
do
  case "${myopt}" in
    u) # -u for "usage": see script usage
      myUsage 1;;
    h) # -h for "help": less the relevant documentation and see script usage
      sed -n '2,18p; 19q' $mysh/scriptinit.sh | command less
      myUsage 2
      ;;
    l) # -l <1|2|3> for "level": sets the template level
      shlevel=${OPTARG}
      if [ $shlevel != $lev1 ] && [ $shlevel != $lev2 ] && [ $shlevel != $lev3 ]
      then
        myUsage 3
      fi
      ;;
    \?)
      myUsage 4;;
  esac
done
shift $(($OPTIND-1))
if [ ${#} -ne 2 ] # check that the right number of script paramters have been filled
then
  myUsage 5
fi
scriptname=${1}    # the name of the script to be templated upon
copyyear=${2}      # the current year (for the copyright)


# pre-check
if ! [[ $copyyear =~ ^[0-9]+$ ]] || [ $copyyear -eq 0 ]
then
  echo 'ERROR 1111: copyyear is not a positive integer!' 1>&2
  echo "copyyear = $copyyear" 1>&2
  echo 'exiting...' 1>&2
  exit 1
fi



# copy the specified template, replace the relevant strings, and remove the backup files (*.bak, necessary for execution on Mac OS X)

cp $mysh/scriptinit_${shlevel}.txt $scriptname
sed -i'.bak' "s/${thescript}/${scriptname}/g" $scriptname; rm -f $scriptname.bak
sed -i'.bak' "s/${thename}/${myname}/g" $scriptname; rm -f $scriptname.bak
sed -i'.bak' "s/${theyear}/${copyyear}/g" $scriptname; rm -f $scriptname.bak
chmod 755 $scriptname



## FIN
