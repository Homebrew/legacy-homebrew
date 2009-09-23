# This script contains bash completions for brew.
#
# To use, edit your .bashrc and add the line:
#   source `brew --prefix`/Library/Contributions/brew_bash_completion.sh

_brew_to_completion()
{
    local actions cur prev
    local cellar_contents formulae which_cellar brew_base

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # We only complete unabbreviated commands...
    actions="configure create edit generate homepage info install list link options prune remove search unlink update"
    
    # Subcommand list
    if [[ ( ${COMP_CWORD} -eq 1 ) && ( ${COMP_WORDS[0]} == brew )  ]] ; then
        COMPREPLY=( $(compgen -W "${actions}" -- ${cur}) )
        return 0
    # Subcommands
    else
        brew_base=`which brew`
        brew_base=`dirname ${brew_base}`/..
        
        case ${prev} in
            # Commands that take a formula...
            edit|install|home|homepage)
                formulae=`ls ${brew_base}/Library/Formula/ | sed "s/\.rb//g"`
                COMPREPLY=( $(compgen -W "${formulae}" -- ${cur}) )
                return 0
            ;;

            # Commands that take an existing brew...
            abv|info|list|link|ls|ln|rm|remove|uninstall|unlink)
                cellar_contents=`ls ${brew_base}/Cellar/`
                COMPREPLY=( $(compgen -W "${cellar_contents}" -- ${cur}) )
                return 0
            ;;
            
        esac
    fi
}

complete -F _brew_to_completion brew
