#
# This file defines functions that help fancy output to the terminal
#
# @author Alfredo Mazzinghi
#

ESC='\e'

# create space for the rendering
#
# @param $1 the number of spaces
#
function space() {
    for (( i = 0; i < $1; i++)); do
	echo ""
    done
}

# get the cursor position
# http://stackoverflow.com/questions/2575037/how-to-get-the-cursor-position-in-bash
function query_cursor_position() {
    # enable stdin
    exec < /dev/tty
    # save terminal settings
    oldtty=$(stty -g)
    # set tty to raw mode with echo of chars and 0 chars for a completed read
    stty raw -echo min 0
    echo -ne "${ESC}[6n" > /dev/tty
    # report cursor position in the format <ESC>[<row>;<col>
    # into $rcp as an array separated by ;
    # zsh read function!
    read -r -d R rcp
    # restore terminal settings
    stty $oldtty
    # change index from 1-based to 0-based to be used with tput
    local unescaped_rcp=${rcp:2}
    local row=$((${unescaped_rcp%%;*} - 1))
    local col=$((${unescaped_rcp##*;} - 1))
    echo "${row};${col}"
}

# render a text at given position
#
# @param $1 row index
# @param $2 column index
# @param $3 text
#
function draw() {
    tput sc
    tput cup ${1} ${2}
    echo -ne "${ESC}[${1};${2}f"
    echo -nE ${3}
    tput rc
}

# render a block of text starting from given position
#
# @param $1 row index
# @param $2 column index
# @param $3 text
#
function draw_block() {
    local row=${1}
    local lines=$(echo -E ${3} | wc -l)
    local txt=""
    for line in $(seq 1 ${lines}); do
	txt=$(echo -nE ${3} | cut -d$'\n' -f ${line})
	draw ${row} ${2} ${txt}
	row=$((${row} + 1))
    done
#    echo -ne ${3} | cut -d$'\n' -f $(seq 1 ${lines} | tr "\n" "," | sed "s/,$//g")
}


# same as draw block but rows are
# relative to current position
# 
# @param $1 relative row index
# @param $2 absolute columns index
# @param $3 text
#
function draw_block_relative_row() {
    # relative row index
    local curr=$(query_cursor_position)
    local row=$(( ${1} + ${curr%%;*} ))
    draw_block ${row} ${2} ${3}
}

####
# Helper for draw_row
# delete a block from the list of blocks given the separator
# @param $1 blocks list
# @param $2 separator sequence
# @returns the blocks list without the first item
#
function list_delete() {
echo -E ${1} | 
awk "
BEGIN{ stop=1 }
{
pos=match(\$0, /${2}(.*)/, result) 
if (pos != 0 && stop == 1) { print result[1]; stop = 0; }
else if (stop == 0) { print \$0; }
}"
}

####
# Helper for draw_row
# returns the first block from the list of blocks given the separator
# @param $1 blocks list
# @param $2 separator sequence
# @returns the first item
#
function list_first() {
echo -E ${1} | 
awk "
BEGIN{ stop=0 }
{
pos=match(\$0, /(.*)${2}/, result) 
if (pos != 0 && stop == 0) { print result[1]; stop = 1; }
if (stop == 0) { print \$0; }
}"
}

####
# Helper remove color escapes
#
# used to get the true length of the lines
# @param $1 the text to be evaluated
#
function strip_colors() {
echo -E ${1} | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?(;[0-9]{1,2})?)?[m|K]//g"
}

# draw a responsive row element
# if the screen is too small automatically wrap
# @param $1 the margin to leave from top left and right
# @param $2 column spacing between columns in the same row
# @param $3 list of Y paddings to add to each block (this is for centering) (space separated list)
# @param $4 blocks separator sequence
# @param $5 the list of text blocks separated by a separating sequence in $4
#
function draw_row() {
    # normalize variable names
    local margin=${1}
    local spacing=${2}
    local padding=${3}
    local block_separator=${4}
    local block_list=${5}
    # terminal geometry
    resize > /dev/null 
    local max_rows=${LINES}
    local max_cols=${COLUMNS}
    # current cursor position
    local cursor=$(query_cursor_position)
    local cur_row=${cursor%%;*}
    local cur_col=${cursor##*;}
    # blocks extraction (this assumes that at least one block is give)
    local num_blocks=$(( $(echo ${block_list} | grep -o "${block_separator}" | wc -l) + 1)) #TODO this will not work if there are 2 separators on the same line
    # number of columns used for this row
    local used_cols=0
    # height of the row in term of terminal rows
    local row_height=0
    local txt_rows=0
    local txt_cols=0
    local row_index=0 
    local col_index=0
    local block=0
    # add top margin to the row
    space ${margin}
    for block in $(seq 1 ${num_blocks}); do
	# geometry of the text block to render
	txt_block=$(list_first ${block_list} "${block_separator}")
	block_list=$(list_delete ${block_list} "${block_separator}")
	txt_rows=$(strip_colors ${txt_block} | wc -l)
	txt_cols=$(strip_colors ${txt_block} | wc -L)
	if [[ "$(( 2 * ${margin} + ${txt_cols} + ${used_cols} ))" -lt "${max_cols}" ]]; then
	    # draw inline and update variables
	    ## calculate column index
	    col_index=0
	    if [[ "${block}" -eq "1" ]]; then
		# first block in the row
		# the +1 is needed because we start from col 1
		col_index=$(( ${col_index} + ${margin} + 1))
		used_cols=$(( ${used_cols} + ${margin} ))
	    else
		col_index=$(( ${used_cols} ))
	    fi
	    ## calculate row index (relative)
	    if [[ "$(( ${row_height} - ${txt_rows} ))" -lt "0" ]]; then
		# check that the vertical space is available
		# otherwise add it
		space $(( ${txt_rows} - ${row_height} ))
		row_height=${txt_rows}
	    fi
	    row_index=$(( -${row_height} + 1 ))
	    ## draw block
	    draw_block_relative_row ${row_index} ${col_index} ${txt_block}
	    ## update row width
	    # the +1 is because used_cols points to the last 
	    # used col which is used and must be skipped
	    used_cols=$(( ${used_cols} + ${txt_cols} + ${spacing} + 1 ))
	else
	    # wrap to another row all the remaining columns recursively
	    # append txt_block to block_list again
	    block_list="${txt_block}${block_list}"
	    draw_row ${margin} ${spacing} ${padding} ${block_separator} ${block_list}
	    break
	fi
    done
}
