#!/bin/bash

for FILE in ${@}
do
  if [[ ${#FILE} > 1 ]]; then
    if [[ ! -f $FILE ]]
    then
      echo -e "ERROR! \n The PATH ${FILE} does not exist!"
    fi
  else
     echo -e "ERROR! \n The PATH ${FILE} does not exist!"
  fi
done