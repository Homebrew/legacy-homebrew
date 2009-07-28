_brew_to_completion()
{
    local actions cur prev
    local cellar_contents formulae which_cellar brew_base

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    actions="install rm list info ln edit"
    
    # Command list
    if [[ ( ${COMP_CWORD} -eq 1 ) && ( ${COMP_WORDS[0]} == brew )  ]] ; then
        COMPREPLY=( $(compgen -W "${actions}" -- ${cur}) )
        return 0
    # Handle subcommands
    else
        brew_base=`which brew`
        brew_base=`dirname ${brew_base}`/..
        
        # Commands that take an existing brew...
        if [[ ($prev == "list") || ($prev == "ln") || ($prev == "rm") ]] ; then
            cellar_contents=`ls ${brew_base}/Cellar/`
            COMPREPLY=( $(compgen -W "${cellar_contents}" -- ${cur}) )
            return 0
        # Commands that take a formula...
        elif [[ ($prev == "install") ]] ; then
            formulae=`ls ${brew_base}/Library/Formula/ | sed "s/\.rb//g"`
            COMPREPLY=( $(compgen -W "${formulae}" -- ${cur}) )
            return 0
        fi
    fi
}

complete -F _brew_to_completion brew
