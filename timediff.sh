#!/bin/bash
##  timediff.sh
##  By: Charlie Payne
##  Copyright (C): 2018
##  License: see LICENSE (GNU GPL v3)
## DESCRIPTION
##  this script takes in two times (in the format DDD:HH:MM:SS) and outputs their absolute difference (in the format HH:MM:SS)
##  to get the current time in the format DDD:HH:MM:SS one can execute: date +%j:%H:%M:%S (my alias is `rawdate`)
##  in pseudo-formula: HH:MM:SS = abs(DDDF:HHF:MMF:SSF - DDDI:HHI:MMI:SSI)
##  it has the restrictions: 001 <= DDD <= 366, 00 <= HH =< 23, 00 <= MM <= 59, 00 <= SS <= 59
##  NOTE: it will break for calculating differences that cross over New Year's...
## PARAMETERS
##  1) timeI=${1}    # the initial (I) time, in the format DDD:HH:MM:SS
##  2) timeF=${2}    # the final (F) time, in the format DDD:HH:MM:SS
timeI=${1}    # the initial (I) time, in the format DDD:HH:MM:SS
timeF=${2}    # the final (F) time, in the format DDD:HH:MM:SS
somevalue='<insert value>'    # <insert description, this is used below>



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


# parse the input
if [ -z ${1} ]
then
  echo 'ERRROR 0: god is empty, just like me...' 1>&2
  exit 1
elif [ ${1} = '-u' ]
then
  echo "Usage: `basename ${0}` <timeI> <timeF>" 1>&2
  exit 1
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
if [ $DDDI -lt 1 ] || [ 366 -lt $DDDI ]
then
  echo 'ERROR: timeI is out of range!' 1>&2
  echo "DDDI = $DDDI" 1>&2
  echo 'exiting...' 1>&2
  exit 1 1>&2
fi
if [ $HHI -lt 0 ] || [ 23 -lt $HHI ]
then
  echo 'ERROR: timeI is out of range!' 1>&2
  echo "HHI = $HHI" 1>&2
  echo 'exiting...' 1>&2
  exit 1
fi
if [ $MMI -lt 0 ] || [ 59 -lt $MMI ]
then
  echo 'ERROR: timeI is out of range!' 1>&2
  echo "MMI = $MMI" 1>&2
  echo 'exiting...' 1>&2
  exit 1
fi
if [ $SSI -lt 0 ] || [ 59 -lt $SSI ]
then
  echo 'ERROR: timeI is out of range!' 1>&2
  echo "SSI = $SSI" 1>&2
  echo 'exiting...' 1>&2
  exit 1
fi
if [ $DDDF -lt 1 ] || [ 366 -lt $DDDF ]
then
  echo 'ERROR: timeF is out of range!' 1>&2
  echo "DDDF = $DDDF" 1>&2
  echo 'exiting...' 1>&2
  exit 1
fi
if [ $HHF -lt 0 ] || [ 23 -lt $HHF ]
then
  echo 'ERROR: timeF is out of range!' 1>&2
  echo "HHF= $HHF" 1>&2
  echo 'exiting...' 1>&2
  exit 1
fi
if [ $MMF -lt 0 ] || [ 59 -lt $MMF ]
then
  echo 'ERROR: timeFis out of range!' 1>&2
  echo "MMF = $MMF" 1>&2
  echo 'exiting...' 1>&2
  exit 1
fi
if [ $SSF -lt 0 ] || [ 59 -lt $SSF ]
then
  echo 'ERROR: timeF is out of range!' 1>&2
  echo "SSF = $SSF" 1>&2
  echo 'exiting...' 1>&2
  exit 1
fi



# perform the calculation
DIFFS=$(($TOTSF-$TOTSI)) # total difference in seconds
DHH=$(($DIFFS/3600)) # calculate the HH (recall that $((...)) automatically floors to an integer in bash)
deltatmp=$(($DIFFS - 3600*$DHH))
DMM=$(($deltatmp/60))
DSS=$(($deltatmp - 60*DMM))

# output in the final format
DHH=$(rezero $DHH)
DMM=$(rezero $DMM)
DSS=$(rezero $DSS)
echo "${DHH}:${DMM}:${DSS}" # return the difference in the format HH:MM:SS



## FIN
