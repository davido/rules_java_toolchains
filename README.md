# rules_java_toolchains

Non-LTS JDK toolchains for Bazel, packaged as a standalone bzlmod module on top
of [`rules_java`](https://github.com/bazelbuild/rules_java).

`rules_java` ships remote JDK toolchains for the LTS line (8, 11, 17, 21, 25) and
is deliberately conservative about carrying non-LTS releases, since each one is
only supported for six months. This module adds those short-lived releases
(currently **JDK 27**) without forking `rules_java`: it reuses `rules_java`'s own
`remote_java_repository`, `default_java_toolchain`, and `java_runtime_version_alias`
machinery and only contributes the archive catalog.

## What it provides

- Runtime toolchains for JDK 27 across linux (x86_64/aarch64/ppc64le/riscv64/s390x),
  macOS (x86_64/aarch64), and Windows (x86_64), selectable with
  `--java_runtime_version=remotejdk_27` (or `=27`).
- `@rules_java_toolchains//toolchains:remotejdk_27` — the runtime label, for use
  as a `java_runtime = ...` attribute.
- `@rules_java_toolchains//toolchains:toolchain_jdk_27` — a compile toolchain that
  runs `javac` on JDK 27, selectable with `--java_language_version=27`. (The LTS
  toolchains top out at JDK 25, whose `javac` rejects source/target 27.)

## Usage

```starlark
# MODULE.bazel
bazel_dep(name = "rules_java", version = "9.9.0")
bazel_dep(name = "rules_java_toolchains", version = "0.0.1")
```

```
# .bazelrc
build:java27 --java_language_version=27
build:java27 --java_runtime_version=remotejdk_27
build:java27 --tool_java_language_version=27
build:java27 --tool_java_runtime_version=remotejdk_27
```

```
bazel build --config=java27 //...
```

### Before this module is published

Until it lands on the Bazel Central Registry, pin it from GitHub:

```starlark
bazel_dep(name = "rules_java_toolchains", version = "0.0.1")
git_override(
    module_name = "rules_java_toolchains",
    remote = "https://github.com/davido/rules_java_toolchains.git",
    commit = "<pin a commit>",
)
```

## Example

`examples/consuming` is a self-contained workspace that consumes this module via
`local_path_override` and builds a Java target at language level 27:

```
cd examples/consuming
bazel run --config=java27 //:hello   # prints "Hello from JDK 27"
```

## Adding the next non-LTS release

1. Add the archive structs to `jdk/repositories.bzl` (name, `target_compatible_with`,
   `sha256`, `strip_prefix`, `urls`, `version`), mirroring the JDK 27 entries.
2. Add a `remote_jdkNN_repos()` macro and call it from `jdk/extensions.bzl`.
3. List the new repos in `MODULE.bazel` (`use_repo` + `register_toolchains`).
4. Add the `remotejdk_NN` alias and `toolchain_jdk_NN` to `toolchains/BUILD.bazel`.
5. Drop a release from the catalog once it reaches end of support.

## License

Apache License 2.0. See [LICENSE](LICENSE).
