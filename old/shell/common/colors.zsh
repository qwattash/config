# 256 color terminal utilities and colors
# see misc.flogisoft.com/bash/tip_colors_and_formatting
# color composition $FgPrefix + $myColorCode + "m"

typeset -AHg FX FG BG ANSI

FX=(
    reset     "%{[00m%}"
    bold      "%{[01m%}" no-bold      "%{[22m%}"
    italic    "%{[03m%}" no-italic    "%{[23m%}"
    underline "%{[04m%}" no-underline "%{[24m%}"
    blink     "%{[05m%}" no-blink     "%{[25m%}"
    reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done



# # grayscale
# typeset -AHg FGray BGray
# for color in {232..255}; do
#     FGray[(($color - 232))]=$FG[$color]
#     BGray[(($color - 232))]=$BG[$color]
# done

# # non-grayscale and non-ansi are in the rage
# # 16-232 -> 6x6x6 color space
# #
# # Z axis = red component
# # Y axis = green component
# # X axis = blue component
# typeset -AHg CS

# #
# # Get index in the offset 3D array
# # $1 x
# # $2 y
# # $3 z
# #
# function _index() {
#     print $(( 36*$3 + 6*$2 + $1 ))
# }

# # for code in {016..232}; do
# for code in {016..252}; do
#     r=$(($code - 16))
#     z=$(($r / 36))
#     r=$(($r % 36))
#     y=$(($r / 6))
#     x=$(($r % 6))
#     CS[$(_index $x $y $z)]=$FG[$code]
# done

# for z in {0..5}; do
#     for y in {0..5}; do
# 	for x in {0..5}; do
# 	    print -n "$CS[$(_index $x $y $z)] "
# 	done
# 	print ""
#     done
#     print "\n"
# done

# ansi colors
ANSI[black]=$FG[000]
ANSI[red]=$FG[001]
ANSI[green]=$FG[002]
ANSI[yellow]=$FG[003]
ANSI[blue]=$FG[004]
ANSI[purple]=$FG[005]
ANSI[cyan]=$FG[006]
ANSI[white]=$FG[007]
ANSI[br-black]=$FG[008]
ANSI[br-red]=$FG[009]
ANSI[br-green]=$FG[010]
ANSI[br-yellow]=$FG[011]
ANSI[br-blue]=$FG[012]
ANSI[br-purple]=$FG[013]
ANSI[br-cyan]=$FG[014]
ANSI[br-white]=$FG[015]
