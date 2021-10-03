#! /bin/bash
set -eo pipefail
case "${1}" in
  halt)
    if test -f vagrant_loc -a -r vagrant_loc; then
      x=$(. vagrant_loc && echo $v) && \
      $x status | awk '/running/{gsub(/ $/, "", $0);print $1}' | \
      xargs -P4 -I {} $x halt {};
    fi
    ;;
  provision)
    sudo -l >/dev/null && \
    if test -f vagrant_loc -a -r vagrant_loc; then
      x=$(. vagrant_loc && echo $v) && \
      rm -f text && \
      if ! systemctl status salt-master >/dev/null; then
         rm -f pub_fingerprint
         touch no_salt;
      else
         rm -f no_salt
         sudo salt-key -F master | awk '/pub/{print $2}' > pub_fingerprint;
      fi && \
      $x status | awk '/not created/{gsub(/ $/, "", $0);print $1}' | \
      xargs -P4 -I {} $x up --provision {};
    fi
    ;;
  reload)
    if test -f vagrant_loc -a -r vagrant_loc; then
      x=$(. vagrant_loc && echo $v) && \
      $x status | awk '/running/{gsub(/ $/, "", $0);print $1}' | \
      xargs -P4 -I {} $x reload {};
    fi
    ;;
  run)
    if test -f vagrant_loc -a -r vagrant_loc; then
      x=$(. vagrant_loc && echo $v) && \
      $x status | awk '/poweroff/{gsub(/ $/, "", $0);print $1}' | \
      xargs -P4 -I {} $x up {};
    fi
    ;;
  *)
    echo "Please include provision, run, reload, or halt.";
    exit 1
    ;;
esac
