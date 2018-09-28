#!/bin/bash
##  iso4.sh
##  By: Charlie Payne
##  Copyright (C): 2018
##  License: see LICENSE (GNU GPL v3)
## DESCRIPTION
##  this will take in a word and output its ISO 4 shortened version
##  I will add in more ISO 4 words as I need them (i.e., this is an incomplete ---- dictionary ----)
##  if the word is not found in the ---- dictionary ----, then two options can follow:
##    either, the word is in the so-called ---- exceptions dictionary ---- then we simply output the input
##    or, we output the input with a "missing" tag
## PARAMETERS
##  1) theword=${1}    # a single word
PURPLE=$(tput setaf 5)  # get the purple [5] text environment  (usage base)
RED=$(tput setaf 1)     # get the red [1] text environment     (usage error)
BOLD=$(tput bold)       # get the bold text environment        (default values)
UNDERLINE=$(tput smul)  # get the underline text environment   (variable names)
RESET=$(tput sgr0)      # don't forget to reset afterwards!
erro(){ echo "$@" 1>&2; }
myUsage(){ erro "${PURPLE}Usage (${RED}${1}${PURPLE}):${RESET} `basename ${0}` [-u for usage] <${UNDERLINE}theword${RESET}>"; exit 1; }
theword=${1}    # a single word
misstag='<-MISSING'    # the tag for a missing word
stdon='on'
stdoff='off'


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
  myUsage "option -${1:1} not recognized"
elif [ ${#} -ne 1 ] # check that the right number of script paramters have been filled
then
  myUsage 'incorrect number of script parameters'
fi
colon=$stdoff
missing=$stdoff
last=$(echo -n $theword | tail -c 1)
if [ $last = ':' ]
then
  theword=${theword%':'} # trim the trailing colon ;)
  colon=$stdon
fi


# ---- dictionary ----
if [ $theword = 'The' ] || [ $theword = 'the' ] || [ $theword = 'on' ] || [ $theword = 'in' ] || [ $theword = 'and' ] || [ $theword = 'of' ]
then
  theword=''
elif [ $theword = 'Advances' ]
then
  theword='Adv.'
elif [ $theword = 'Analysis' ]
then
  theword='Anal.'
elif [ $theword = 'Annual' ]
then
  theword='Ann.'
elif [ $theword = 'Applied' ]
then
  theword='Appl.'
elif [ $theword = 'Atomic' ]
then
  theword='At.'
elif [ $theword = 'Chemical' ] || [ $theword = 'Chemistry' ]
then
  theword='Chem.'
elif [ $theword = 'Conference' ] || [ $theword = 'Conferences' ]
then
  theword='Conf.'
elif [ $theword = 'Communications' ]
then
  theword='Commun.'
elif [ $theword = 'Computer' ] || [ $theword = 'Computational' ]
then
  theword='Comput.'
elif [ $theword = 'European' ]
then
  theword='Eur.'
elif [ $theword = 'Experimental' ]
then
  theword='Exp.'
elif [ $theword = 'International' ]
then
  theword='Int.'
elif [ $theword = 'Journal' ]
then
  theword='J.'
elif [ $theword = 'Mathematics' ] || [ $theword = 'Mathematical' ]
then
  theword='Math.'
elif [ $theword = 'Modern' ]
then
  theword='Mod.'
elif [ $theword = 'Nuclear' ]
then
  theword='Nuc.'
elif [ $theword = 'Numerical' ]
then
  theword='Numer.'
elif [ $theword = 'Letters' ]
then
  theword='Lett.'
elif [ $theword = 'Particle' ] || [ $theword = 'Particles' ]
then
  theword='Part.'
elif [ $theword = 'Physics' ] || [ $theword = 'Physical' ] || [ $theword = 'Physica' ]
then
  theword='Phys.'
elif [ $theword = 'Proceedings' ]
then
  theword='Proc.'
elif [ $theword = 'Progress' ]
then
  theword='Prog.'
elif [ $theword = 'Reports' ]
then
  theword='Rep.'
elif [ $theword = 'Review' ] || [ $theword = 'Reviews' ]
then
  theword='Rev.'
elif [ $theword = 'Series' ]
then
  theword='Ser.'
elif [ $theword = 'Science' ] || [ $theword = 'Sciences' ]
then
  theword='Sci.'
elif [ $theword = 'Scripta' ]
then
  theword='Scr.'
elif [ $theword = 'Supplements' ]
then
  theword='Suppl.'
elif [ $theword = 'Theoretical' ]
then
  theword='Theor.'
else
  missing=$stdon
fi

# ---- exceptions dictionary ----
if [ $missing = $stdon ] # don't remove this, trust me...
then
  if [ $theword = 'Data' ] || [ $theword = 'Energy' ] || [ $theword = 'High' ] || [ $theword = 'Pure' ] || [ $theword = 'Tables' ]
  then
    missing=$stdoff
  fi
fi


# add the missing tag, if applicable
if [ $missing = $stdon ]
then
  theword="($theword)$misstag"
fi

# reappend the colon, if applicable
if [ $theword ] && [ $colon = $stdon ]
then
  theword="${theword}:"
fi

# output
echo $theword


## FIN
