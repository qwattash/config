#
# This shows the fortune message in a color among the 8
# standard possible colors (except background)
#

source ~/git/config/shell/common/colors.sh


function build_fortune_widget() {
    #data=$(fortune | sed "s/^/\\${Red}/g")
    #echo -ne ${data}
    fortune | sed "s/^/\\\\${Red}/g" | xargs -0 -L 1 echo -ne
}
