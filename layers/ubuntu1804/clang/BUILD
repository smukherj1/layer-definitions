# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@bazel_skylib//:bzl_library.bzl", "bzl_library")
load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")
load("@io_bazel_rules_docker//contrib/automatic_container_release:packages_metadata.bzl", "packages_metadata")
load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load(
    "@io_bazel_rules_docker//docker/toolchain_container:toolchain_container.bzl",
    "language_tool_layer",
)
load(":clang.bzl", "clang_env")
load(":revisions.bzl", "CLANG_INSTALLER")

licenses(["notice"])  # Apache 2.0

package(default_visibility = ["//visibility:public"])

exports_files(glob(["*.yaml"]))

bzl_library(
    name = "lib",
    srcs = glob(["*.bzl"]),
)

download_pkgs(
    name = "clang_debs",
    image_tar = "@ubuntu1804//image",
    packages = [
        "libstdc++-7-dev",
    ],
)

# Transform the packages metadata csv produced by download_pkgs into a YAML
# file.
packages_metadata(
    name = "metadata",
    metadata_csv = ":clang_debs_metadata.csv",
)

pkg_tar(
    name = "clang_tar",
    package_dir = "/usr/local/",
    strip_prefix = ".",
    tags = ["manual"],
    deps = [
        "@ubuntu1804_clang_release//file",
    ],
)

pkg_tar(
    name = "libcxx_tar",
    package_dir = "/usr/local/",
    strip_prefix = ".",
    tags = ["manual"],
    deps = [
        "@ubuntu1804_libcxx_release//file",
    ],
)

language_tool_layer(
    name = "clang-ltl",
    base = "@ubuntu1804//image",
    env = clang_env,
    installables_tar = "@ubuntu1804_clang_debs//file",
    tars = [
        ":clang_tar",
        ":libcxx_tar",
    ],
)

# Used by tests only.
genrule(
    name = "generate_clang_yaml",
    srcs = ["tests.yaml.tpl"],
    outs = ["tests.yaml"],
    cmd = "sed 's|{_CLANG_REVISION}|" + CLANG_INSTALLER.revision.lstrip("r") + "|' <$< >$@",
)

container_test(
    name = "test",
    configs = [
        ":tests.yaml",
    ],
    image = ":clang-ltl",
    verbose = True,
)
