#!/bin/bash
#
# Copyright (c) 2020-2021 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0

# script common across operator-metadata, devfileregistry, and pluginregistry

SCRIPT_DIR=$(cd "$(dirname "$0")" || exit; pwd)
YAML_ROOT="$1"

cheYamls=$("$SCRIPT_DIR"/list_che_yaml.sh "$YAML_ROOT")

# Note: optional -f flag will force this transformation even on an incompatible architecture,
# so we can call this script from crw-operator/build/scripts/insert-related-images-to-csv.sh
if [[ "$(uname -m)" != "x86_64" ]] || [[ "$2" == "-f" ]]; then
    for yaml in $cheYamls; do
        # use full tag, eg. 1.0-12 instead of 1.0, as 1.0 might resolve to different tag/digest when using find_image.sh
        sed -E -i 's|eap-xp1-openjdk11-openshift-rhel8:.*|eap-xp1-openj9-11-openshift-rhel8:1.0-12|g' "$yaml"
        sed -E -i 's|plugin-java8-rhel8|plugin-java8-openj9-rhel8|g' "$yaml"
        sed -E -i 's|plugin-java11-rhel8|plugin-java11-openj9-rhel8|g' "$yaml"
    done
fi
