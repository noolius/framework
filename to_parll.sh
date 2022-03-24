#! /bin/bash
set -eo pipefail
case "${1}" in
  halt)
    if test -f vagrant_loc -a -r vagrant_loc; then
      # shellcheck disable=SC2154
      x=$(. vagrant_loc && echo "$v") && \
      "$x" status | awk '/running/{gsub(/ $/, "", $0);print $1}' | \
      parallel "$x halt {}";
    fi
    ;;
  provision)
    if test -f vagrant_loc -a -r vagrant_loc; then
      x=$(. vagrant_loc && echo "$v") && \
      rm -f text && \
      if ! systemctl status salt-master >/dev/null; then
         rm -f pub_fingerprint
         touch no_salt;
      else
         rm -f no_salt
         sudo -K && sudo salt-key -F master | awk '/pub/{print $2}' > pub_fingerprint
	       sudo -K;
      fi && \
      "$x" status | awk '/not created/{gsub(/ $/, "", $0);print $1}' | \
      parallel --delay 15 "$x up --provision {}";
    fi
    ;;
  reload)
    if test -f vagrant_loc -a -r vagrant_loc; then
      x=$(. vagrant_loc && echo "$v") && \
      "$x" status | awk '/running/{gsub(/ $/, "", $0);print $1}' | \
      parallel --delay 5 "$x reload {}";
    fi
    ;;
  run)
    if test -f vagrant_loc -a -r vagrant_loc; then
      x=$(. vagrant_loc && echo "$v") && \
      "$x" status | awk '/poweroff/{gsub(/ $/, "", $0);print $1}' | \
      parallel --delay 5 "$x up {}";
    fi
    ;;
  update)
    if test -f vagrant_loc -a -r vagrant_loc; then
      x=$(. vagrant_loc && echo "$v") && \
      "$x" status | awk '/running/{gsub(/ $/, "", $0);print $1}' | \
      parallel --sshdelay 5 "echo {} ; $x ssh {} -- doas apk -U upgrade";
    fi
    ;;
  *)
    echo "Please use provision, run, reload, update, or halt.";
    exit 1
    ;;
esac
