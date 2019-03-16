#!/bin/bash
# Script to exit emulators used by Recalbox
function getcpid() {
local cpids="$(pgrep -P $1)"
    for cpid in $cpids;
    do
        pidarray+=($cpid)
        getcpid $cpid
    done
}

smart_wait() {
    local PID=$1
    while [[ -e /proc/$PID ]]
    do
        sleep 0.05
    done
}


motherpid="$(pgrep -f -n emulatorlauncher.py)"
[ "$motherpid" ] && getcpid $motherpid || exit
for ((z=${#pidarray[*]}-1; z>-1; z--))
do
 kill ${pidarray[z]} && smart_wait ${pidarray[z]}
done
