<div align="center">

# asdf-ast-grep [![Build](https://github.com/michael-delphos/asdf-ast-grep/actions/workflows/build.yml/badge.svg)](https://github.com/michael-delphos/asdf-ast-grep/actions/workflows/build.yml) [![Lint](https://github.com/michael-delphos/asdf-ast-grep/actions/workflows/lint.yml/badge.svg)](https://github.com/michael-delphos/asdf-ast-grep/actions/workflows/lint.yml)

[ast-grep](https://ast-grep.github.io/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add ast-grep
# or
asdf plugin add ast-grep https://github.com/michael-delphos/asdf-ast-grep.git
```

ast-grep:

```shell
# Show all installable versions
asdf list-all ast-grep

# Install specific version
asdf install ast-grep latest

# Set a version globally (on your ~/.tool-versions file)
asdf global ast-grep latest

# Now ast-grep commands are available
ast-grep --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/michael-delphos/asdf-ast-grep/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Michael Quinn](https://github.com/michael-delphos/)
