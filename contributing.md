# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

asdf plugin test ast-grep https://github.com/michael-delphos/asdf-ast-grep.git "ast-grep --version"
```

Tests are automatically run in GitHub Actions on push and PR.
