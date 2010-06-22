# This script contains bash completions for brew.
#
# To use, edit your .bashrc and add the line:
#   source `brew --prefix`/Library/Contributions/brew_bash_completion.sh

_brew_to_completion()
{
    local actions cur prev prev_index
    local cellar_contents formulae

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    # We usually only complete unabbreviated commands.
    actions="--cache --config --prefix cat cleanup configure create deps doctor edit home info install link list log outdated prune remove search unlink update uses"

    if [[ ( ${COMP_CWORD} -eq 1 ) && ( ${COMP_WORDS[0]} == brew ) ]]; then
        # Subcommand list.
        COMPREPLY=( $(compgen -W "${actions}" -- ${cur}) )
        return 0
    else
        # Find the previous non-switch word
        prev_index=$((COMP_CWORD - 1))
        prev="${COMP_WORDS[prev_index]}"
        while [[ $prev == -* ]]; do
            prev_index=$((prev_index - 1))
            prev="${COMP_WORDS[prev_index]}"
        done

        case ${prev} in
            # Commands that take a formula.
            cat|deps|edit|home|homepage|info|install|log|uses)
                formulae=$(ls $(brew --repository)/Library/Formula/ | sed "s/\.rb//g")
                COMPREPLY=( $(compgen -W "${formulae}" -- ${cur}) )
                return 0
            ;;

            # Commands that take an existing brew.
            abv|cleanup|link|list|ln|ls|remove|rm|uninstall|unlink)
                cellar_contents=$(ls $(brew --cellar))
                COMPREPLY=( $(compgen -W "${cellar_contents}" -- ${cur}) )
                return 0
            ;;

        esac
    fi
}

complete -F _brew_to_completion brew
