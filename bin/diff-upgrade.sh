#!/bin/bash

doUpgrade() {
    helm upgrade -i $@
}

DIR=$(dirname "${BASH_SOURCE[0]}")
$DIR/diff upgrade -C 3 $@

force="${HELM_FORCE_DIFF_UPGRADE:-0}"

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
