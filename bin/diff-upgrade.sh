#!/bin/bash
set -euo pipefail

doUpgrade() {
    helm upgrade -i $@
}

./diff upgrade -C 3 $@

if [ "$HELM_FORCE_DIFF_UPGRADE" = "1" ]
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
