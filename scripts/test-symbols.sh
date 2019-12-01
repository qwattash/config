#!/bin/zsh

colorReset='\033[0m'
#colorBgWhite='\033[107m'
colorBg='\033[104m'
colorFg='\033[94m'

codes=('E0B0' 'E0B1' 'E0B2' 'E0B3' 'E0B4' 'E0B5' 'E0B6' 'E0B7' 'E0B8' 'E0B9' 'E0BA' 'E0BC' 'E0BD' 'E0BE' 'E0BF')

for code in $codes; do
    echo "$colorBg Test U+$code \\u$code X $colorReset$colorFg\\u$code \\u$code$colorReset$colorBg XXX $colorReset"
    echo "---------------------------"
done
