#!/bin/bash
##  timediff.sh
##  By: Charlie Payne
##  Copyright (C): 2018
##  License: see LICENSE (GNU GPL v3)
## DESCRIPTION
##  this script takes in two times (in the format DDD:HH:MM:SS) and outputs their absolute difference (in the format HH:MM:SS and/or in total seconds)
##  to get the current time in the format DDD:HH:MM:SS one can execute: date +%j:%H:%M:%S (my alias is `rawdate`)
##  in pseudo-formula: HH:MM:SS = abs(DDDF:HHF:MMF:SSF - DDDI:HHI:MMI:SSI)
##  it has the restrictions: 001 <= DDD <= 366, 00 <= HH =< 23, 00 <= MM <= 59, 00 <= SS <= 59
## KNOWN BUGS / DESIRED FEATURES
##  -- it will break for calculating differences that cross over New Year's...
## OPTIONS
##  -u for "usage": see script usage
##  -h for "help": less the relevant documentation and see script usage
##  -s for "seconds also": output the difference in total seconds also
##  -S for "seconds only": output the difference in total seconds only
## PARAMETERS
##  1) timeI=${1}    # the initial (I) time, in the format DDD:HH:MM:SS
##  2) timeF=${2}    # the final (F) time, in the format DDD:HH:MM:SS
PURPLE=$(tput setaf 5)  # get the purple [5] text environment  (usage base)
RED=$(tput setaf 1)     # get the red [1] text environment     (usage error)
BOLD=$(tput bold)       # get the bold text environment        (default values)
UNDERLINE=$(tput smul)  # get the underline text environment   (variable names)
RESET=$(tput sgr0)      # don't forget to reset afterwards!
erro(){ echo "$@" 1>&2; }
myUsage(){ erro "${PURPLE}Usage (${RED}${1}${PURPLE}):${RESET} `basename ${0}` [-u for usage] [-h for help] [-s for seconds also] [-S for seconds only] <DDD:HH:MM:SS> <DDD:HH:MM:SS>"; exit 1; }
timeI=${1}    # the initial (I) time, in the format DDD:HH:MM:SS
timeF=${2}    # the final (F) time, in the format DDD:HH:MM:SS
mysh=$MYSH    # this must point to where this current script lives
szero='0'
sone='1'
stwo='2'



# function prototype: this trims the leading zeros off a value (seems unnecessarily complicated, maybe there's an easier way...)
trimzero(){
  local value=${1}
  local vallength=${#value}
  local trimvalue=$value
  if [ $vallength -gt 1 ]
  then
    for ((i=0; i<=$vallength-2; i++))
    do
      digit=${value:$i:1} # this gets the first digit
      if [ $digit = '0' ]
      then
        trimvalue=${trimvalue:1} # this cuts the first digit
      else
        break
      fi
    done
  fi
  echo $trimvalue
}

# function prototype: this takes numbers with only one digit and puts a '0' out front
rezero(){
  local value=${1}
  if [ ${#value} -eq 1 ]
  then
    value="0${value}"
  fi
  echo $value
}


# pre-parse the script parameters
if [ -z "${1}" ]
then
  erro 'ERROR 0: god is empty, just like me...'
  exit 1
fi
Sswitch=$szero # this gets turned on by the -s or -S option
while getopts ":uhsS" myopt # filter the script options
do
  case "${myopt}" in
    u) # -u for "usage": see script usage
      myUsage;;
    h) # -h for "help": less the relevant documentation and see script usage
      sed -n '2,20p; 21q' $mysh/timediff.sh | command less
      myUsage
      ;;
    s) # -s for "seconds also": output the difference in total seconds also
      Sswitch=$sone;;
    S) # -S for "seconds only": output the difference in total seconds only
      Sswitch=$stwo;;
    \?)
      myUsage "option -${OPTARG} not recognized";;
  esac
done
shift $(($OPTIND-1))
if [ ${#} -ne 2 ] # check that the right number of script paramters have been filled
then
  myUsage 'incorrect number of script parameters'
fi
timeI=${1}    # the initial (I) time, in the format DDD:HH:MM:SS
timeF=${2}    # the final (F) time, in the format DDD:HH:MM:SS


# parse the input
if [[ $timeI != ???:??:??:?? ]] || [[ $timeF != ???:??:??:?? ]]
then
  myUsage 'incorrect format of script parameters'
fi
DDDI=${timeI%%:*} # this gets DDD
HHI=${timeI#*:} # this gets HH:MM:SS
HHI=${HHI%%:*} # this gets HH
MMI=${timeI%:*} # this gets DDD:HH:MM
MMI=${MMI##*:} # this gets MM
SSI=${timeI##*:} # this gets SS
DDDI=$(trimzero $DDDI)
HHI=$(trimzero $HHI)
MMI=$(trimzero $MMI)
SSI=$(trimzero $SSI)
TOTSI=$((24*3600*$DDDI + 3600*HHI + 60*MMI + SSI))
DDDF=${timeF%%:*} # this gets DDD
HHF=${timeF#*:} # this gets HH:MM:SS
HHF=${HHF%%:*} # this gets HH
MMF=${timeF%:*} # this gets DDD:HH:MM
MMF=${MMF##*:} # this gets MM
SSF=${timeF##*:} # this gets SS
DDDF=$(trimzero $DDDF)
HHF=$(trimzero $HHF)
MMF=$(trimzero $MMF)
SSF=$(trimzero $SSF)
TOTSF=$((24*3600*$DDDF + 3600*HHF + 60*MMF + SSF))
if [ $TOTSF -lt $TOTSI ] # then just switch 'em...
then
  OLDI=$TOTSI
  OLDF=$TOTSF
  TOTSF=$OLDI
  TOTSI=$OLDF
fi


# pre-check
if [ $Sswitch != $szero ] && [ $Sswitch != $sone ] && [ $Sswitch != $stwo ]
then
  erro 'ERROR 1207: Sswitch is out of bounds!'
  erro "Sswitch = $Sswitch"
  erro 'exiting...'
  exit 1
fi
if [ $DDDI -lt 1 ] || [ 366 -lt $DDDI ]
then
  erro 'ERROR 0508: timeI is out of range!'
  erro "DDDI = $DDDI"
  erro 'exiting...'
  exit 1
fi
if [ $HHI -lt 0 ] || [ 23 -lt $HHI ]
then
  erro 'ERROR 1135: timeI is out of range!'
  erro "HHI = $HHI"
  erro 'exiting...'
  exit 1
fi
if [ $MMI -lt 0 ] || [ 59 -lt $MMI ]
then
  erro 'ERROR 9056: timeI is out of range!'
  erro "MMI = $MMI"
  erro 'exiting...'
  exit 1
fi
if [ $SSI -lt 0 ] || [ 59 -lt $SSI ]
then
  erro 'ERROR 0071: timeI is out of range!'
  erro "SSI = $SSI"
  erro 'exiting...'
  exit 1
fi
if [ $DDDF -lt 1 ] || [ 366 -lt $DDDF ]
then
  erro 'ERROR 2863: timeF is out of range!'
  erro "DDDF = $DDDF"
  erro 'exiting...'
  exit 1
fi
if [ $HHF -lt 0 ] || [ 23 -lt $HHF ]
then
  erro 'ERROR 1285: timeF is out of range!'
  erro "HHF= $HHF"
  erro 'exiting...'
  exit 1
fi
if [ $MMF -lt 0 ] || [ 59 -lt $MMF ]
then
  erro 'ERROR 3104: timeFis out of range!'
  erro "MMF = $MMF"
  erro 'exiting...'
  exit 1
fi
if [ $SSF -lt 0 ] || [ 59 -lt $SSF ]
then
  erro 'ERROR 5771: timeF is out of range!'
  erro "SSF = $SSF"
  erro 'exiting...'
  exit 1
fi



# perform the calculation
DIFFS=$(($TOTSF-$TOTSI)) # total difference in seconds
if [ $Sswitch = $szero ] || [ $Sswitch = $sone ]
then
  DHH=$(($DIFFS/3600)) # calculate the HH (recall that $((...)) automatically floors to an integer in bash)
  deltatmp=$(($DIFFS - 3600*$DHH))
  DMM=$(($deltatmp/60))
  DSS=$(($deltatmp - 60*DMM))

  DHH=$(rezero $DHH)
  DMM=$(rezero $DMM)
  DSS=$(rezero $DSS)
fi

# output in the final format
if [ $Sswitch = $szero ]
then
  echo "${DHH}:${DMM}:${DSS}" # return the difference in the format HH:MM:SS
elif [ $Sswitch = $sone ]
then
  echo "${DHH}:${DMM}:${DSS} = ${DIFFS} seconds" # return the difference in the format HH:MM:SS and in total seconds
elif [ $Sswitch = $stwo ]
then
  echo "${DIFFS}" # return the difference in total seconds only
fi



## FIN
