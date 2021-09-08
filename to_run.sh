#! /bin/bash
set -e
set -x
set -o pipefail

x=$(. vagrant_loc && echo $v) && \
rm -f text && \
$x status | \
                                 awk '
			     /poweroff/{gsub(/ $/, "", $0);print $1}
                             ' | \
                                 xargs -P4 -I {} $x up {}
