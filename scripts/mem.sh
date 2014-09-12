#!/bin/bash

PLATFORM="$(uname)"

if [ "$PLATFORM" = "Linux" ]; then
    free -m | perl -awlne 'printf "Mem:%sM,%sM\n",$F[2],$F[3] if $_ =~ "buffers/cache"'
else
    echo "Mem:Unkonw platform"
fi

