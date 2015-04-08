#!/usr/bin/env bash

# sucks since pip show fails to find depencies for a lot of stuff like scikit-learn

PACKAGE=$(echo $1 | awk -F= '{print $1}')
VERSION=$(echo $1 | awk -F= '{print $2}')

REQUIREMENTS=$(pip show $PACKAGE | grep Requires: | awk -F: '{print $2}' | tr "," " ")
echo "reqs=$REQUIREMENTS"
for REQUIREMENT in $REQUIREMENTS
do
    POSSIBLE_SPECIFIC_VERSION=$(cat requirements.txt | grep "^$REQUIREMENT==")
    SPECIFIC_VERSION=${POSSIBLE_SPECIFIC_VERSION-$REQUIREMENT}
    echo ">$SPECIFIC_VERSION"
    bash $0 $SPECIFIC_VERSION
done
echo "install $1"
