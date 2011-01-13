# Bash completion script for brew(1)
#
# To use, edit your .bashrc and add:
#   source `brew --prefix`/Library/Contributions/brew_bash_completion.sh

_brew_to_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    # Subcommand list
    [[ ${COMP_CWORD} -eq 1 ]] && {
        local actions="--cache --cellar --config --help --env --prefix
            --repository --version -h cat cleanup configure create deps doctor
            edit home info install link list log outdated prune remove search
            uninstall unlink update uses"
        local ext=$(\ls $(brew --repository)/Library/Contributions/examples |
                    sed -e "s/\.rb//g" -e "s/brew-//g")
        COMPREPLY=( $(compgen -W "${actions} ${ext}" -- ${cur}) )
        return
    }

    local action="${COMP_WORDS[1]}"

    case "$action" in
    # Commands that take formulae
    --cache|--cellar|--prefix|cat|deps|edit|fetch|home|homepage|info|install|log|options|uses)
        local ff=$(\ls $(brew --repository)/Library/Formula | sed "s/\.rb//g")
        local af=$(\ls $(brew --repository)/Library/Aliases 2> /dev/null | sed "s/\.rb//g")
        COMPREPLY=( $(compgen -W "${ff} ${af}" -- ${cur}) )
        return
        ;;
    # Commands that take existing brews
    abv|cleanup|link|list|ln|ls|remove|rm|test|uninstall|unlink)
        COMPREPLY=( $(compgen -W "$(\ls $(brew --cellar))" -- ${cur}) )
        return
        ;;
    esac
}

complete -o bashdefault -o default -F _brew_to_completion brew
