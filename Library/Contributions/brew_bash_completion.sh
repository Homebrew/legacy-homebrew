# Bash completion script for brew(1)
#
# To use, edit your .bashrc and add:
#   source `brew --prefix`/Library/Contributions/brew_bash_completion.sh

_brew_to_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    # Subcommand list
    [[ ${COMP_CWORD} -eq 1 ]] && {
        local actions="--cache --cellar --config --env --prefix --repository audit cat cleanup
            configure create deps doctor edit fetch help home info install link list log options
            outdated prune remove search test uninstall unlink update uses versions"
        local ext=$(\ls $(brew --repository)/Library/Contributions/examples |
                    sed -e "s/\.rb//g" -e "s/brew-//g")
        COMPREPLY=( $(compgen -W "${actions} ${ext}" -- ${cur}) )
        return
    }

    # Find the previous non-switch word
    local prev_index=$((COMP_CWORD - 1))
    local prev="${COMP_WORDS[prev_index]}"
    while [[ $prev == -* ]]; do
        prev_index=$((--prev_index))
        prev="${COMP_WORDS[prev_index]}"
    done

    case "$prev" in
    # Commands that take a formula
    cat|deps|edit|fetch|home|homepage|info|install|log|missing|options|uses|versions)
        # handle standard --options
        if [[ "$prev" == "install" && "$cur" == --* ]]; then
            local opts=$(
                local opts=( --force --verbose --debug --use-clang --use-gcc --use-llvm --ignore-dependencies --HEAD )
                for o in ${opts[*]}; do
                    [[ " ${COMP_WORDS[*]} " =~ " $o " ]] || echo "$o"
                done
            )
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
        fi
        local ff=$(\ls $(brew --repository)/Library/Formula | sed "s/\.rb//g")
        local af=$(\ls $(brew --repository)/Library/Aliases 2> /dev/null | sed "s/\.rb//g")
        COMPREPLY=( $(compgen -W "${ff} ${af}" -- ${cur}) )
        return
        ;;
    # Commands that take an existing brew
    abv|cleanup|link|list|ln|ls|remove|rm|test|uninstall|unlink)
        COMPREPLY=( $(compgen -W "$(\ls $(brew --cellar))" -- ${cur}) )
        return
        ;;
    # Complete --options for selected brew
    *)
        if [[ ${COMP_WORDS[1]} == "install" && "$cur" == --* ]]; then
            local opts=$(
                local opts=( $(brew options --compact "$prev") )
                for o in ${opts[*]}; do
                    [[ " ${COMP_WORDS[*]} " =~ " $o " ]] || echo "$o"
                done
            )
            COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
            return
        fi
        ;;
    esac
}

complete -o bashdefault -o default -F _brew_to_completion brew
