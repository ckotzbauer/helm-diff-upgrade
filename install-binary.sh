#!/bin/bash

on_exit() {
    exit_code=$?
    if [ ${exit_code} -ne 0 ]; then
        echo "helm-diff-upgrade install hook failed. Please remove the plugin using 'helm plugin remove diff-upgrade' and install again." > /dev/stderr
    fi
    exit ${exit_code}
}
trap on_exit EXIT

version="$(cat plugin.yaml | grep "version" | cut -d '"' -f 2)"
echo "Downloading and installing helm-diff-upgrade ${version} ..."

binary_url=""
if [ "$(uname)" == "Darwin" ] || [ "$(uname)" == "Linux" ]; then
    binary_url="https://raw.githubusercontent.com/code-chris/helm-diff-upgrade/${version}/bin/diff-upgrade.sh"
fi

if [ -z "${binary_url}" ]; then
    echo "Unsupported OS type"
    exit 1
fi

mkdir -p "bin"
mkdir -p "releases/${version}"
binary_filename="releases/${version}.sh"

# Download binary
(
    if [ -x "$(which curl 2>/dev/null)" ]; then
        curl -sSL "${binary_url}" -o "${binary_filename}"
    elif [ -x "$(which wget 2>/dev/null)" ]; then
        wget -q "${binary_url}" -O "${binary_filename}"
    else
      echo "ERROR: no curl or wget found to download files." > /dev/stderr
      exit 1
    fi
)

mv "releases/${version}.sh" "bin/diff-upgrade"


####
# Download latest helm-diff binary
####

if [ -x "$(which curl 2>/dev/null)" ]; then
    latest_diff=$(curl -sSL https://api.github.com/repos/databus23/helm-diff/tags | grep "name" | cut -d '"' -f 4 | head -n1)
elif [ -x "$(which wget 2>/dev/null)" ]; then
    latest_diff=$(wget -qnv https://api.github.com/repos/databus23/helm-diff/tags -O- | grep "name" | cut -d '"' -f 4 | head -n1)
else
    echo "ERROR: no curl or wget found to download files." > /dev/stderr
    exit 1
fi

echo "Downloading and installing helm-diff ${latest_diff} ..."

diff_url=""
if [ "$(uname)" == "Darwin" ]; then
    diff_url="https://github.com/databus23/helm-diff/releases/download/${latest_diff}/helm-diff-macos.tgz"
elif [ "$(uname)" == "Linux" ]; then
    diff_url="https://github.com/databus23/helm-diff/releases/download/${latest_diff}/helm-diff-linux.tgz"
fi

if [ -z "${diff_url}" ]; then
    echo "Unsupported OS type"
    exit 1
fi

diff_filename="releases/${latest_diff}.tgz"
mkdir -p "releases/${latest_diff}"

(
    if [ -x "$(which curl 2>/dev/null)" ]; then
        curl -sSL "${diff_url}" -o "${diff_filename}"
    elif [ -x "$(which wget 2>/dev/null)" ]; then
        wget -q "${diff_url}" -O "${diff_filename}"
    else
      echo "ERROR: no curl or wget found to download files." > /dev/stderr
      exit 1
    fi
)

tar xzf "${diff_filename}" -C "releases/${latest_diff}"
mv "releases/${latest_diff}/diff/bin/diff" "bin/diff"

exit 0
