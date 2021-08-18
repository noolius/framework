#! /bin/bash
x=$(. vagrant_loc && echo $v) && \
rm -f text && \
$x status | \
                                 awk '
			     /poweroff/{gsub(/ $/, "", $0);print $1}
                             ' | \
                                 xargs -P3 -I {} $x up {}
