#!/bin/bash

arch="$(uname -s)"

if [[ "$arch" = "Linux" ]]; then
    free -m | perl -awlne 'printf "Mem:%sM,%sM\n",$F[2],$F[3] if /buffers\/cache/'
elif [[ "$arch" = "Darwin" ]]; then
    top -l 1 | head -n 10 | perl -awlne 'printf "Mem:%s,%s\n",$F[5],$F[1] if /^PhysMem/'
else
    echo "Mem:Unknown platform"
fi

