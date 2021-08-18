#! /bin/bash
sudo -l >/dev/null && \
x=$(. vagrant_loc && echo $v) && \
rm -f text && \
if ! systemctl status salt-master >/dev/null; then
   rm -f pub_fingerprint
   touch no_salt;
else
   rm -f no_salt
   sudo salt-key -F master | awk '/pub/{print $2}' > pub_fingerprint;
fi && \
$x status | \
                                 awk '
			     /not created/{gsub(/ $/, "", $0);print $1}
                             ' | \
                                 xargs -P3 -I {} $x up --provision {}
