#!/usr/bin/env bash

arch="$(uname -s)"

if [[ "$arch" = "Linux" ]]; then
    free -m | perl -awlne 'printf "Mem:%sM,%sM\n",$F[2],$F[3] if /buffers\/cache/'
elif [[ "$arch" = "Darwin" ]]; then
  vm_stat | sed 's/\.$//' | awk '
    /^(Pages (wired down|(in)?active|speculative)|Pages occupied by compressor)/ {
      used_memory_with_cache += $NF
    }

    /^(Pages purgeable|File-backed pages)/ {
      cached_memory += $NF
    }

    /^Pages free/ {
      free_memory += $NF
    }

    END {
      used_memory_mega_bytes = ((used_memory_with_cache - cached_memory) * 4096) / 1024 / 1024
      free_memory_mega_bytes = ((cached_memory + free_memory) * 4096) / 1024 / 1024
      printf("Mem:%dM,%dM\n", used_memory_mega_bytes, free_memory_mega_bytes)
    }
    '
else
    echo "Mem:Unknown platform"
fi

