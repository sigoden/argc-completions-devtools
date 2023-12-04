#!/usr/bin/env bash

# @cmd Dump all kind of shell' setup scripts
setup-shells() {
    shells=( bash zsh powershell fish nushell elvish xonsh tcsh )
    for s in "${shells[@]}"; do
        $ARGC_COMPLETIONS_ROOT/scripts/setup-shell.sh $s
        echo 
    done
}

# @cmd Check command in a group
# @flag -i --invert     List exist commands other than non-exist commands
# @arg group[`_choice_group`]
check:group() {
    mapfile -t cmds < <(_helper_cmds $1)
    for cmd in "${cmds[@]}"; do
        if command -v "$cmd" >/dev/null; then
            if [[ -n "$argc_invert" ]]; then
                echo $cmd
            fi
        else
            if [[ -z "$argc_invert" ]]; then
                echo $cmd
            fi
        fi
    done
}

# @cmd Check command all groups
# @flag -i --invert     List exist commands other than non-exist commands
# @flag -c --compact    Output cmd only
check:all() {
    mapfile -t groups < <(_choice_group)
    for group in "${groups[@]}"; do
        if [[ -z "$argc_compact" ]]; then
            echo "### $group"
            check:group $group
            echo
        else
            cmds=( $(check:group $group | tr '\n' ' ') )
            if [[ -n "$cmds" ]]; then
                echo -n "${cmds[*]} "
            fi
        fi
    done
}

# @cmd List commands in groups
# @arg groups+[`_choice_group`]
list() {
    for group in "${argc_groups[@]}"; do
        _helper_cmds "$group"
    done
}

# @cmd Format group txts
format() {
    for f in group/*.txt; do
        cat $f | sort -n -t';' -k1,1 | sponge $f
        sed -i '/^\s*$/ d' $f
    done
}

# @cmd Check missed commands
check:missed() {
    # data="$(curl -fsSL https://raw.githubusercontent.com/sigoden/argc-completions/main/MANIFEST.md)"
    data="$(cat ../argc-completions/MANIFEST.md)"
    if [[ -z "$data" ]]; then
        exit 1
    fi
    mapfile -t all_cmds < <(echo "$data" | sed -n 's/^- \[\(\S\+\)\].*/\1/p')
    mapfile -t registered_cmds < <(_helper_registered_cmds)
    missed=()
    for i in "${all_cmds[@]}"; do
        found=false
        for j in "${registered_cmds[@]}"; do
            if [[ $i == $j ]]; then
                found=true
                break
            fi
        done
        if [[ $found == false ]]; then
            missed+=("$i")
        fi
    done

    echo "${missed[@]}"
}

# @cmd
debug() {
    _helper_registered_cmds
}

# @cmd Install commands in asdf group
# @option --skip <LINENUM>
asdf() {
    _group_lines asdf
    for line in "${lines[@]}"; do
        IFS=';' read -r value1 value2 <<<"$line"
        if [[ -n "$value2" ]]; then
            cmd="$value1"
            IFS='@' read -r value3 value4 <<<"$value2"
            version="${value4:-latest}"
            plugin="$value3"
        else
            IFS='@' read -r value3 value4 <<<"$value1"
            version="${value4:-latest}"
            plugin="$value3"
            cmd="$plugin"
        fi
        echo "### asdf $cmd"
        installer:asdf "$plugin" "$version"
        echo
    done
}

# @cmd Install commands in cargo group
# @option --skip <LINENUM>
cargo() {
    _group_lines cargo
    for line in "${lines[@]}"; do
        IFS=';' read -r name value <<<"$line"
        echo "### cargo $name"
        command cargo install "${value:-$name}"
        echo
    done
}

# @cmd Install commands in composer group
# @option --skip <LINENUM>
composer() {
    _group_lines composer
    for line in "${lines[@]}"; do
        IFS=';' read -r name value <<<"$line"
        echo "### composer $name"
        command composer global require "$value" --dev --with-all-dependencies --no-plugins --no-interaction
        echo
    done
}

# @cmd Install commands in gem group
# @option --skip <LINENUM>
gem() {
    _group_lines gem
    for line in "${lines[@]}"; do
        IFS=';' read -r name value <<<"$line"
        echo "### gem $name"
        command gem install "${value:-$name}"
        echo
    done
}

# @cmd Install commands in ghrelease group
# @option --skip <LINENUM>
ghrelesae() {
    _group_lines ghrelease
    for line in "${lines[@]}"; do
        IFS=';' read -r name value <<<"$line"
        echo "### ghrelease $name"
        xinstall gh "$value:$name"
        echo
    done
}

# @cmd Install commands in go group
# @option --skip <LINENUM>
go() {
    _group_lines go
    for line in "${lines[@]}"; do
        IFS=';' read -r name value <<<"$line"
        if [[ "$value" != *'@'* ]]; then
            value="$value@latest"
        fi
        echo "### go $name"
        command go install "$value"
        echo
    done
}

# @cmd Install commands in nix group
# @option --skip <LINENUM>
nix() {
    _group_lines nix
    for line in "${lines[@]}"; do
        IFS=';' read -r name value <<<"$line"
        echo "### nix $name"
        command nix-env -iA "nixpkgs.${value:-$name}"
        echo
    done
}

# @cmd Install commands in npm group
# @option --skip <LINENUM>
npm() {
    _group_lines npm
    for line in "${lines[@]}"; do
        IFS=';' read -r name value <<<"$line"
        echo "### npm $name"
        command npm install -g "${value:-$name}"
        echo
    done
}

# @cmd Install commands in pip group
# @option --skip <LINENUM>
pipx() {
    _group_lines pipx
    for line in "${lines[@]}"; do
        IFS=';' read -r name value <<<"$line"
        echo "### pipx $name"
        command pipx install --include-deps "${value:-$name}"
        echo
    done
}

# @cmd Install commands in sdk group
sdk() {
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    _group_lines sdk
    for line in "${lines[@]}"; do
        IFS=';' read -r value1 value2 <<<"$line"
        if [[ -n "$value2" ]]; then
            cmd="$value1"
            IFS='@' read -r value3 version <<<"$value2"
            app="$value3"
        else
            IFS='@' read -r value3 version <<<"$value1"
            app="$value3"
            cmd="$app"
        fi
        if [[ -z "$version" ]]; then
            version="$(curl -fsSL https://api.sdkman.io/2/candidates/$app/linuxx64/versions/all | tr ',' '\n' | head -n 1)"
        fi
        echo "### sdk $cmd"
        sdk install $app $version
        echo
    done
}

# @cmd Install commands with apt
# @arg list <file>
apt() {
    mapfile -t lines < $argc_list
    for line in "${lines[@]}"; do
        IFS=';' read -r name value <<<"$line"
        echo "### apt $name"
        command sudo apt install -y "${value:-$name}"
        echo
    done
}


# @cmd Install the command by asdf
# @arg plugin
# @arg version
installer:asdf() {
    plugin="$1"
    version="${2:-latest}"
    command asdf plugin add "$plugin"
    command asdf install "$plugin" "$version"
    command asdf global "$plugin" "$version"
}

_group_lines() {
    if [[ -n "$argc_skip" ]]; then skip_args="1,$argc_skip d"; fi
    mapfile -t lines < <(cat group/$1.txt | sed "$skip_args")
}

_choice_group() {
    ls -1 group | sed 's/.txt$//'
}

_helper_registered_cmds() {
    mapfile -t groups < <(_choice_group)
    for group in "${groups[@]}"; do
        _helper_cmds "$group"
        echo
    done
}

_helper_cmds() {
    if [[ "$1" == "manual"* ]]; then
        _helper_manual_cmds "$1"
    else
        _helper_group_cmds "$1"
    fi
}

_helper_group_cmds() {
    sed -n 's/^\([^;]\+\).*/\1/p' group/$1.txt
}

_helper_manual_cmds() {
    ls -1 group/$1 | xargs -I{} basename {} .sh
}

eval "$(argc --argc-eval "$0" "$@")"
