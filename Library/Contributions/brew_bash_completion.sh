# Bash completion script for brew(1)
#
# To use, edit your .bashrc and add:
#   source `brew --prefix`/Library/Contributions/brew_bash_completion.sh
#
# The __brew_ps1() function can be used to annotate your PS1 with
# Homebrew debugging information; it behaves similarly to the __git_ps1()
# function provided by the git's bash completion script.
#
# For example, the prompt string
#     PS1='\u@\h \W $(__brew_ps1 "(%s)") $'
#
# would result in a prompt like
#    user@hostname cwd $
#
# but if you are currently engaged in an interactive or debug install,
# (i.e., you invoked `brew install` with either '-i' or '-d'), then the
# prompt would look like
#     user@hostname cwd (formula_name|DEBUG) $
#
# You can customize the output string, e.g. $(__brew_ps1 "[%s]") would
# output "[formula_name|DEBUG]". The default (if you do not provide a
# format argument) is to print "(formula_name|DEBUG)" prefixed with a
# single space.

_brew_to_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    # Subcommand list
    [[ ${COMP_CWORD} -eq 1 ]] && {
        local actions="--cache --cellar --config --env --prefix --repository audit cat cleanup
            configure create deps diy doctor edit fetch help home info install link list log options
            outdated prune remove search test uninstall unlink update upgrade uses versions"
        local ext=$(\ls $(brew --repository)/Library/Contributions/examples 2> /dev/null |
                    sed -e "s/\.rb//g" -e "s/brew-//g")
        COMPREPLY=( $(compgen -W "${actions} ${ext}" -- ${cur}) )
        return
    }

    # some flags take arguments
    # kind of pointless to use a case statement here, but it's cleaner
    # than a bunch of string comparisons and leaves room for future
    # expansion
    case "${COMP_WORDS[1]}" in
    # flags that take a formula
    --cache|--cellar|--prefix)
        local ff=$(\ls $(brew --repository)/Library/Formula 2> /dev/null | sed "s/\.rb//g")
        local af=$(\ls $(brew --repository)/Library/Aliases 2> /dev/null | sed "s/\.rb//g")
        COMPREPLY=( $(compgen -W "${ff} ${af}" -- ${cur}) )
        return
        ;;
    esac

    # Find the previous non-switch word
    local prev_index=$((COMP_CWORD - 1))
    local prev="${COMP_WORDS[prev_index]}"
    while [[ $prev == -* ]]; do
        prev_index=$((--prev_index))
        prev="${COMP_WORDS[prev_index]}"
    done

    # handle subcommand options
    if [[  "$cur" == --* ]]; then
        case "${COMP_WORDS[1]}" in
        cleanup)
            local opts=$([[ "${COMP_WORDS[*]}" =~ "--force" ]] || echo "--force")
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        create)
            local opts=$(
                local opts=(--autotools --cmake --no-fetch)
                for o in ${opts[*]}; do
                    [[ "${COMP_WORDS[*]}" =~ "$o" ]] || echo "$o"
                done
            )
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        deps)
            local opts=$(
                local opts=(--1 --all --tree)
                for o in ${opts[*]}; do
                    [[ "${COMP_WORDS[*]}" =~ "$o" ]] || echo "$o"
                done
            )
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        diy|configure)
            local opts=$(
                local opts=(--set-version --set-name)
                for o in ${opts[*]}; do
                    [[ "${COMP_WORDS[*]}" =~ "$o" ]] || echo "$o"
                done
            )
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        fetch)
            local opts=$(
                local opts=(--deps --force --HEAD)
                for o in ${opts[*]}; do
                    [[ "${COMP_WORDS[*]}" =~ "$o" ]] || echo "$o"
                done
            )
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        info|abv)
            local opts=$(
                local opts=(--all --github)
                for o in ${opts[*]}; do
                    [[ "${COMP_WORDS[*]}" =~ "$o" ]] || echo "$o"
                done
            )
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        install)
            local opts=$(
                local opts=(--force --verbose --debug --use-clang --use-gcc
                    --use-llvm --ignore-dependencies --build-from-source --HEAD
                    --interactive --fresh --devel $(brew options --compact "$prev"))

                # options that make sense with '--interactive'
                if [[ "${COMP_WORDS[*]}" =~ "--interactive" ]]; then
                    opts=(--force --git --use-clang --use-gcc --use-llvm --HEAD --devel)
                fi

                for o in ${opts[*]}; do
                    [[ "${COMP_WORDS[*]}" =~ "$o" ]] || echo "$o"
                done
            )
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        list|ls)
            local opts=$(
                local opts=(--unbrewed --verbose --versions)

                # the three options for list are mutually exclusive
                for o in ${opts[*]}; do
                    if [[ "${COMP_WORDS[*]}" =~ "$o" ]]; then
                        opts=()
                    else
                        echo "$o"
                    fi
                done
            )
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        options)
            local opts=$(
                local opts=(--all --compact --installed)
                for o in ${opts[*]}; do
                    [[ "${COMP_WORDS[*]}" =~ "$o" ]] || echo "$o"
                done
            )
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        outdated)
            local opts=$([[ "${COMP_WORDS[*]}" =~ "--quiet" ]] || echo "--quiet")
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        search)
            local opts=$(
                local opts=(--fink --macports)
                for o in ${opts[*]}; do
                    [[ "${COMP_WORDS[*]}" =~ "$o" ]] || echo "$o"
                done
            )
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        uninstall|remove|rm)
            local opts=$([[ "${COMP_WORDS[*]}" =~ "--force" ]] || echo "--force")
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        update)
            local opts=$(
                local opts=(--rebase --verbose)
                for o in ${opts[*]}; do
                    [[ "${COMP_WORDS[*]}" =~ "$o" ]] || echo "$o"
                done
            )
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        uses)
            local opts=$([[ "${COMP_WORDS[*]}" =~ "--installed" ]] || echo "--installed")
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
            ;;
        esac
    fi

    # find the index of the *first* non-switch word
    # we can use this to allow completion for multiple formula arguments
    local cmd_index=1
    while [[ ${COMP_WORDS[cmd_index]} == -* ]]; do
        cmd_index=$((++cmd_index))
    done

    case "${COMP_WORDS[cmd_index]}" in
    # Commands that take a formula
    audit|cat|deps|edit|fetch|home|homepage|info|install|log|missing|options|uses|versions)
        local ff=$(\ls $(brew --repository)/Library/Formula 2> /dev/null | sed "s/\.rb//g")
        local af=$(\ls $(brew --repository)/Library/Aliases 2> /dev/null | sed "s/\.rb//g")
        COMPREPLY=( $(compgen -W "${ff} ${af}" -- ${cur}) )
        return
        ;;
    # Commands that take an existing brew
    abv|cleanup|link|list|ln|ls|remove|rm|test|uninstall|unlink)
        COMPREPLY=( $(compgen -W "$(\ls $(brew --cellar))" -- ${cur}) )
        return
        ;;
    # Commands that take an outdated brew
    upgrade)
        COMPREPLY=( $(compgen -W "$(brew outdated --quiet)" -- ${cur}) )
        return
        ;;
    esac
}

__brew_ps1 ()
{
    [[ -n $HOMEBREW_DEBUG_INSTALL ]] &&
    printf "${1:- (%s)}" "$HOMEBREW_DEBUG_INSTALL|DEBUG"
}

complete -o bashdefault -o default -F _brew_to_completion brew
