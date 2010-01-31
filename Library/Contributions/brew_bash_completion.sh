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
    actions="cleanup configure create deps edit generate homepage info install list link options prune remove search unlink update uses"
    
    # Subcommand list
    if [[ ( ${COMP_CWORD} -eq 1 ) && ( ${COMP_WORDS[0]} == brew )  ]] ; then
        COMPREPLY=( $(compgen -W "${actions}" -- ${cur}) )
        return 0
    # Subcommands
    else
        brew_base=`brew --repository`
        
        case ${prev} in
            # Commands that take a formula...
            deps|edit|install|home|homepage|uses)
                formulae=`ls ${brew_base}/Library/Formula/ | sed "s/\.rb//g"`
                COMPREPLY=( $(compgen -W "${formulae}" -- ${cur}) )
                return 0
            ;;

            # Commands that take an existing brew...
            abv|cleanup|info|list|link|ls|ln|rm|remove|uninstall|unlink)
                cellar_contents=`ls ${brew_base}/Cellar/`
                COMPREPLY=( $(compgen -W "${cellar_contents}" -- ${cur}) )
                return 0
            ;;
            
        esac
    fi
}

complete -F _brew_to_completion brew
