#!/usr/bin/env bash

case "$(uname -s)" in
  Linux)
    free -m | awk '
      /buffers\/cache/ {printf "Mem:%2.2fG,%2.2fG\n", $3 / 1024, $4 / 1024}
    '
    ;;
  Darwin)
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
        used_memory_mega_bytes = ((used_memory_with_cache - cached_memory) * 4096) / 1024 / 1024 / 1024
        free_memory_mega_bytes = ((cached_memory + free_memory) * 4096) / 1024 / 1024 / 1024
        printf("Mem:%2.2fG,%2.2fG\n", used_memory_mega_bytes, free_memory_mega_bytes)
      }
    '
    ;;
  *)
    echo "Mem:Unknown platform"
    ;;
esac
