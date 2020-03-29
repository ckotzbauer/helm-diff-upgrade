#!/bin/bash

force="${HELM_FORCE_DIFF_UPGRADE:-0}"

doUpgrade() {
    helm upgrade -i $@
}

DIR=$(dirname "${BASH_SOURCE[0]}")
$DIR/diff upgrade -C 3 --detailed-exitcode $@
EXIT_CODE=$?

if [ "$EXIT_CODE" = "0" ]
then
    echo "No changes detected!"
    exit 0
fi

if [ "$force" = "1" ]
then
    doUpgrade $@
    exit $?
fi

while true; do
    read -p "Start upgrade of the release? [Yn]" yn
    case $yn in
        [Yy]* ) doUpgrade $@; break;;
        [Nn]* ) exit;;
        * ) doUpgrade $@; break;;
    esac
done
