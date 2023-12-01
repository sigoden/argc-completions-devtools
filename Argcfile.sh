#!/usr/bin/env bash

set -e


# @cmd
setup-shells() {
    shells=( bash zsh powershell fish nushell elvish xonsh tcsh )
    for s in "${shells[@]}"; do
        $ARGC_COMPLETIONS_ROOT/scripts/setup-shell.sh $s
        echo 
    done
}

# @cmd
# @option -k --kind[brew|brew-tap|apt|cargo|npm|pip|gem|scoop|asdf|go|xinstall]
# @option -s --skip-while
# @arg linenum*
install-commands() {
    set +e
    export HOMEBREW_NO_AUTO_UPDATE=1
    export DEBIAN_FRONTEND=noninteractive
    if [[ -z "$argc_linenum" ]]; then
        if [[ -z "$argc_skip_while" ]]; then
            argc_lines=( $(cat UPDATES.md) )
        else
            argc_lines=( $(cat UPDATES.md | sed "1,/^$argc_skip_while;/ d") )
        fi
    else
        argc_lines=( $(cat UPDATES.md | awk -v LINENUM=" ${argc_linenum[*]} " '{if(index(LINENUM, " " NR " ")) {print $0}}') )
    fi
    for line in "${argc_lines[@]}"; do
        IFS=';' read -r cmd method extra <<< "$line"
        if [[ "$method" != "${argc_kind:-$method}" ]]; then
            continue
        fi
        echo "### $cmd ###"
        if ! command -v "${method/-*/}" > /dev/null; then
            echo TODO
            continue
        fi
        case "$method" in
        brew)
            brew install "${extra:-$cmd}"
            ;;
        brew-tap)
            IFS=':' read -r tab pkg <<< "$extra"
            brew tap "$tab"
            brew install "${pkg:-$cmd}"
            ;;
        apt)
            apt install -y "${extra:-$cmd}"
            ;;
        cargo)
            cargo install "${extra:-$cmd}"
            ;;
        npm)
            npm install -g "${extra:-$cmd}"
            ;;
        pip)
            pip install "${extra:-$cmd}"
            ;;
        gem)
            gem install "${extra:-$cmd}"
            ;;
        go)
            if [[ "$extra" != *"@"* ]]; then
                extra="$extra@latest"
            fi
            go install "$extra"
            ;;
        scoop)
            scoop install "${extra:-$cmd}"
            ;;
        asdf)
            IFS=':' read -r plugin version <<< "${extra:-$cmd}"
            version="${version:-latest}"
            asdf plugin add "$plugin"
            asdf install "$plugin" "$version"
            asdf global "$plugin" "$version"
            ;;
        xinstall)
            xinstall gh "$extra:$cmd"
            ;;
        builtin)
            ;;
        *)
            ;;
        esac
        echo
    done
}

# @cmd
# @flag -N --no-ignore
miss-commands() {
    mapfile -t cmds < <(sed -n 's/^\([^;]\+\).*/\1/p' UPDATES.md)
    mapfile -t builtin_cmds < <(cat UPDATES.md | grep '\(;builtin;\|;ignore\)' | sed -n 's/^\([^;]\+\).*/\1/p')
    for cmd in "${cmds[@]}"; do
        if ! command -v "$cmd" >/dev/null; then
            if [[ -n "$argc_no_ignore" ]]; then
                    echo "$cmd"
            else
                if [[ " ${builtin_cmds[*]} " != *" $cmd "* ]]; then
                    echo "$cmd"
                fi
            fi
        fi
    done
}

eval "$(argc --argc-eval "$0" "$@")"
