#!/bin/bash
set -ex

# Find all dependency_update dep spec YAML files.
dep_specs=$(find . -name "deps_spec.yaml" | sed -e "s/^\.\///")

# Run the dependency update syntax checker on each dep spec YAML file.
for d in $dep_specs
do
  docker run -v $PWD/$d:/$d -w="/" gcr.io/asci-toolchain/container_release_tools/dependency_update/validators/syntax \
    -format=dep_spec -specFile=$d -logtostderr=true
done
