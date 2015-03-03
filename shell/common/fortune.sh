#
# This shows the fortune message in a color among the 8
# standard possible colors (except background)
#

source ~/git/config/term/colors.sh

function build_fortune_widget() {
    data=$(fortune | sed "s/^/\\${Red}/g")
    echo -ne ${data}
}
