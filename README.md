# Argc-completion Devtools

Tools for setting up all commands referenced by [argc-completions](https://github.com/sigoden/argc-completions).

## Project Structure

```
├── Argcfile.sh                 # task runner
└── group
    ├── apt1.txt                # ubuntu builtin
    ├── apt2.txt                # ubuntu install
    ├── asdf.txt                # asdf install
    ├── auto.txt                # auto install
    ├── cargo.txt               # cargo install
    ├── composer.txt            # composer install
    ├── gem.txt                 # gem install
    ├── ghrelease.txt           # github release install
    ├── go.txt                  # go install
    ├── linux.txt               # other linux used
    ├── macos1.txt              # macos builtin
    ├── macos2.txt              # macos install
    ├── manual                  # manual install
    ├── nix.txt                 # nix install
    ├── npm.txt                 # npm install
    ├── pipx.txt                # pipx install
    ├── sdk.txt                 # sdkman install
    └── windows.txt             # windows install
```

## Precedure

ghrelease > asdf|sdk > cargo|composer|gemgo|npm|pip > nix > apt