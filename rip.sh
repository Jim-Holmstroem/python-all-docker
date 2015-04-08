#!/usr/bin/env bash

for i in 0 1 2 3 4 5 6 7 8 9
do
    shuf requirements.txt | xargs -I{} pip install {}
done

exit $(pip install -r requirements.txt)
