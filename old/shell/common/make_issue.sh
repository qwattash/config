#!/bin/sh

base=~/.config/shell-commons

source ${base}/arch.sh
source ${base}/stat.sh
source ${base}/fortune.sh

# debug mode
#echo "$(build_arch_art)<sep>$(build_stat_widget)<sep><sep>$(build_fortune_widget)<sep><sep><sep>" | python ${base}/gen-screen.py -m 150 -c 30 -r 2 -t 2 -l 3 -d -s "<sep>"
echo -ne "$(build_arch_art)<sep>$(build_stat_widget)<sep><sep>$(build_fortune_widget | fmt -w 300)<sep><sep><sep>" | python ${base}/gen-screen.py -m 150 -c 30 -r 2 -t 2 -l 3 -s "<sep>" -d
# { build_arch_art;
#   echo -n "<sep>";
#   build_stat_widget;
#   echo -n "<sep><sep>";
#   build_fortune_widget | fmt -w 150;
#   echo -n "<sep><sep><sep>";
# } | python ${base}/gen-screen.py -m 150 -c 30 -r 2 -l 3 -t 2 -s "<sep>"


