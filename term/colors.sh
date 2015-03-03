# 256 color terminal utilities and colors
# see misc.flogisoft.com/bash/tip_colors_and_formatting
# color composition $FgPrefix + $myColorCode + "m"
FgPrefix='\e[38;5;'
BgPrefix='\e[48;5;'

# color end sequence is the same as normal colors
Color_Off='\e[0m'       # Text Reset

Brown='\e[38;5;94m'
Purple='\e[38;5;5m'
Blue='\e[38;5;21m'
Red='\e[38;5;1m'
# light blue
LBlue='\e[38;5;32m'
# very light blue
VLBlue='\e[38;5;45m'
# whitish blue
WBlue='\e[38;5;117m'
# dark blue
DBlue='\e[38;5;18m'
# light gray
LGray='\e[38;5;246m'
# light green
LGreen='\e[38;5;46m'
# dark green
DGreen='\e[38;5;28m'
# light red
LRed='\e[38;5;124m'