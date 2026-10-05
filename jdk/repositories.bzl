# Copyright 2026 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Remote JDK repositories for non-LTS releases (currently JDK 27).

These reuse rules_java's remote_java_repository macro to import the JDK archive
and generate the runtime toolchain definitions; this module only carries the
catalog of archives.
"""

load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@rules_java//toolchains:remote_java_repository.bzl", "remote_java_repository")

# Zulu Community builds (linux/macos/windows) plus Adoptium Temurin for the
# architectures Azul does not publish (ppc64le, riscv64, s390x).
_JDK27_CONFIGS = [
    struct(
        name = "remotejdk27_linux",
        target_compatible_with = ["@platforms//os:linux", "@platforms//cpu:x86_64"],
        sha256 = "ccbc15c4edbedfdcc03c2d29a2aa2c6daf9e6ffb4cda7dd5ece0fcbb37350267",
        strip_prefix = "zulu27.28.101-ca-jdk27.0.0-linux_x64",
        urls = [
            "https://cdn.azul.com/zulu/bin/zulu27.28.101-ca-jdk27.0.0-linux_x64.tar.gz",
            "https://mirror.bazel.build/cdn.azul.com/zulu/bin/zulu27.28.101-ca-jdk27.0.0-linux_x64.tar.gz",
        ],
        version = "27",
    ),
    struct(
        name = "remotejdk27_linux_aarch64",
        target_compatible_with = ["@platforms//os:linux", "@platforms//cpu:aarch64"],
        sha256 = "9fa5bf865783c43840101fcdc3a5222b60daf4fe11f26806247bf807c08aba38",
        strip_prefix = "zulu27.28.101-ca-jdk27.0.0-linux_aarch64",
        urls = [
            "https://cdn.azul.com/zulu/bin/zulu27.28.101-ca-jdk27.0.0-linux_aarch64.tar.gz",
            "https://mirror.bazel.build/cdn.azul.com/zulu/bin/zulu27.28.101-ca-jdk27.0.0-linux_aarch64.tar.gz",
        ],
        version = "27",
    ),
    struct(
        name = "remotejdk27_macos",
        target_compatible_with = ["@platforms//os:macos", "@platforms//cpu:x86_64"],
        sha256 = "b5d64393a228ad8680e5936cb114243118d3f6d87b668f0280ef8c15d674439c",
        strip_prefix = "zulu27.28.101-ca-jdk27.0.0-macosx_x64",
        urls = [
            "https://cdn.azul.com/zulu/bin/zulu27.28.101-ca-jdk27.0.0-macosx_x64.tar.gz",
            "https://mirror.bazel.build/cdn.azul.com/zulu/bin/zulu27.28.101-ca-jdk27.0.0-macosx_x64.tar.gz",
        ],
        version = "27",
        patch_cmds = ["ln -s Contents/Home/* ."],
    ),
    struct(
        name = "remotejdk27_macos_aarch64",
        target_compatible_with = ["@platforms//os:macos", "@platforms//cpu:aarch64"],
        sha256 = "0d8f1d1912fa938ebd95499eb1e8a2a987725fe42aa0dd98497bb604748a8d07",
        strip_prefix = "zulu27.28.101-ca-jdk27.0.0-macosx_aarch64",
        urls = [
            "https://cdn.azul.com/zulu/bin/zulu27.28.101-ca-jdk27.0.0-macosx_aarch64.tar.gz",
            "https://mirror.bazel.build/cdn.azul.com/zulu/bin/zulu27.28.101-ca-jdk27.0.0-macosx_aarch64.tar.gz",
        ],
        version = "27",
        patch_cmds = ["ln -s Contents/Home/* ."],
    ),
    struct(
        name = "remotejdk27_win",
        target_compatible_with = ["@platforms//os:windows", "@platforms//cpu:x86_64"],
        sha256 = "99395b64049c2754005746c4f4b66fdb80c98c3cabaa14d4b25a7f8815c997b8",
        strip_prefix = "zulu27.28.101-ca-jdk27.0.0-win_x64",
        urls = [
            "https://cdn.azul.com/zulu/bin/zulu27.28.101-ca-jdk27.0.0-win_x64.zip",
            "https://mirror.bazel.build/cdn.azul.com/zulu/bin/zulu27.28.101-ca-jdk27.0.0-win_x64.zip",
        ],
        version = "27",
    ),
    struct(
        name = "remotejdk27_linux_ppc64le",
        target_compatible_with = ["@platforms//os:linux", "@platforms//cpu:ppc64le"],
        sha256 = "49a350d6e0fe41f7ee94ffaf101f0951f35042e86c52efa8a751a38fcb2126bb",
        strip_prefix = "jdk-27+35",
        urls = [
            "https://github.com/adoptium/temurin27-binaries/releases/download/jdk-27+35/OpenJDK27U-jdk_ppc64le_linux_hotspot_27_35.tar.gz",
            "https://mirror.bazel.build/github.com/adoptium/temurin27-binaries/releases/download/jdk-27+35/OpenJDK27U-jdk_ppc64le_linux_hotspot_27_35.tar.gz",
        ],
        version = "27",
    ),
    struct(
        name = "remotejdk27_linux_riscv64",
        target_compatible_with = ["@platforms//os:linux", "@platforms//cpu:riscv64"],
        sha256 = "270d74d7732adbaa7af4e153154126c144e6000bb736fd0985421f75075555aa",
        strip_prefix = "jdk-27+35",
        urls = [
            "https://github.com/adoptium/temurin27-binaries/releases/download/jdk-27+35/OpenJDK27U-jdk_riscv64_linux_hotspot_27_35.tar.gz",
            "https://mirror.bazel.build/github.com/adoptium/temurin27-binaries/releases/download/jdk-27+35/OpenJDK27U-jdk_riscv64_linux_hotspot_27_35.tar.gz",
        ],
        version = "27",
    ),
    struct(
        name = "remotejdk27_linux_s390x",
        target_compatible_with = ["@platforms//os:linux", "@platforms//cpu:s390x"],
        sha256 = "5bc83a1453c2b68963218717f138512ce10d7553a68432082e6553ac31fa829b",
        strip_prefix = "jdk-27+35",
        urls = [
            "https://github.com/adoptium/temurin27-binaries/releases/download/jdk-27+35/OpenJDK27U-jdk_s390x_linux_hotspot_27_35.tar.gz",
            "https://mirror.bazel.build/github.com/adoptium/temurin27-binaries/releases/download/jdk-27+35/OpenJDK27U-jdk_s390x_linux_hotspot_27_35.tar.gz",
        ],
        version = "27",
    ),
]

def remote_jdk27_repos():
    """Imports the OpenJDK 27 archives and their runtime toolchain definitions."""
    for item in _JDK27_CONFIGS:
        maybe(
            remote_java_repository,
            name = item.name,
            target_compatible_with = item.target_compatible_with,
            sha256 = item.sha256,
            strip_prefix = item.strip_prefix,
            urls = item.urls,
            version = item.version,
            patch_cmds = getattr(item, "patch_cmds", []),
        )
