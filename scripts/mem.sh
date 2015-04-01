#!/bin/bash

arch="$(uname -s)"

if [[ "$arch" = "Linux" ]]; then
    free -m | perl -awlne 'printf "Mem:%sM,%sM\n",$F[2],$F[3] if $_ =~ "buffers/cache"'
elif [[ "$arch" = "Darwin" ]]; then
    top -l 1 | head -n 10 | perl -awlne 'printf "Mem:%s,%s\n",$F[1],$F[5] if /^PhysMem/'
else
    echo "Mem:Unkonw platform"
fi

