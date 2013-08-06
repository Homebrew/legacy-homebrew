# Bash completion script for brew(1)
#
# To use, add the following to your .bashrc:
#
#    . $(brew --repository)/Library/Contributions/brew_bash_completion.sh
#
# Alternatively, if you have installed the bash-completion package,
# you can create a symlink to this file in one of the following directories:
#
#    $(brew --prefix)/etc/bash_completion.d
#    $(brew --prefix)/share/bash-completion/completions
#
# Installing to etc/bash_completion.d will cause bash-completion to load
# it automatically at shell startup time. If you choose to install it to
# share/bash-completion/completions, it will be loaded on-demand (i.e. the
# first time you invoke the `brew` command in a shell session).

__brewcomp_words_include ()
{
    local i=1
    while [[ $i -lt $COMP_CWORD ]]; do
        if [[ "${COMP_WORDS[i]}" = "$1" ]]; then
            return 0
        fi
        i=$((++i))
    done
    return 1
}

# Find the previous non-switch word
__brewcomp_prev ()
{
    local idx=$((COMP_CWORD - 1))
    local prv="${COMP_WORDS[idx]}"
    while [[ $prv == -* ]]; do
        idx=$((--idx))
        prv="${COMP_WORDS[idx]}"
    done
    echo "$prv"
}

__brewcomp ()
{
    # break $1 on space, tab, and newline characters,
    # and turn it into a newline separated list of words
    local list s sep=$'\n' IFS=$' '$'\t'$'\n'
    local cur="${COMP_WORDS[COMP_CWORD]}"

    for s in $1; do
        __brewcomp_words_include "$s" && continue
        list="$list$s$sep"
    done

    IFS=$sep
    COMPREPLY=($(compgen -W "$list" -- "$cur"))
}

# Don't use __brewcomp() in any of the __brew_complete_foo functions, as
# it is too slow and is not worth it just for duplicate elimination.
__brew_complete_formulae ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local lib=$(brew --repository)/Library
    local ff=$(\ls ${lib}/Formula 2>/dev/null | sed 's/\.rb//g')
    local af=$(\ls ${lib}/Aliases 2>/dev/null | sed 's/\.rb//g')
    local tf tap

    for dir in $(\ls ${lib}/Taps 2>/dev/null); do
        tap="$(echo "$dir" | sed 's|-|/|g')"
        tf="$tf $(\ls -1R "${lib}/Taps/${dir}" 2>/dev/null |
                  grep '.\+.rb' | sed -E 's|(.+)\.rb|'"${tap}"'/\1|g')"
    done

    COMPREPLY=($(compgen -W "$ff $af $tf" -- "$cur"))
}

__brew_complete_installed ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local inst=$(\ls $(brew --cellar))
    COMPREPLY=($(compgen -W "$inst" -- "$cur"))
}

__brew_complete_outdated ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local od=$(brew outdated --quiet)
    COMPREPLY=($(compgen -W "$od" -- "$cur"))
}

__brew_complete_tapped ()
{
    __brewcomp "$(\ls $(brew --repository)/Library/Taps 2>/dev/null | sed 's/-/\//g')"
}

_brew_complete_tap ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--repair"
        return
        ;;
    esac
    __brew_complete_taps
}

__brew_complete_taps ()
{
    if [[ -z "$__brew_cached_taps" ]]; then
        __brew_cached_taps="$(brew ls-taps)"
    fi

    __brewcomp "$__brew_cached_taps"
}

_brew_cleanup ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--force"
        return
        ;;
    esac
    __brew_complete_installed
}

_brew_create ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--autotools --cmake --no-fetch --set-name --set-version"
        return
        ;;
    esac
}

_brew_deps ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--1 --all --tree"
        return
        ;;
    esac
    __brew_complete_formulae
}

_brew_doctor () {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    __brewcomp "$(brew doctor --list-checks)"
}

_brew_diy ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--set-name --set-version"
        return
        ;;
    esac
}

_brew_fetch ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prv=$(__brewcomp_prev)
    case "$cur" in
    --*)
        __brewcomp "
          --deps --force
          --devel --HEAD
          $(brew options --compact "$prv" 2>/dev/null)
          "
        return
        ;;
    esac
    __brew_complete_formulae
}

_brew_info ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--all --github"
        return
        ;;
    esac
    __brew_complete_formulae
}

_brew_install ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prv=$(__brewcomp_prev)

    case "$cur" in
    --*)
        if __brewcomp_words_include "--interactive"; then
            __brewcomp "
                --devel
                --force
                --git
                --HEAD
                --use-clang
                --use-gcc
                --use-llvm
                "
        else
            __brewcomp "
                --build-from-source
                --debug
                --devel
                --force
                --fresh
                --HEAD
                --ignore-dependencies
                --interactive
                --use-clang
                --use-gcc
                --use-llvm
                --verbose
                $(brew options --compact "$prv" 2>/dev/null)
                "
        fi
        return
        ;;
    esac
    __brew_complete_formulae
}

_brew_link ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--dry-run --overwrite --force"
        return
        ;;
    esac
    __brew_complete_installed
}

_brew_list ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        # options to brew-list are mutually exclusive
        if __brewcomp_words_include "--unbrewed"; then
            return
        elif __brewcomp_words_include "--verbose"; then
            return
        elif __brewcomp_words_include "--pinned"; then
            return
        elif __brewcomp_words_include "--versions"; then
            return
        else
            __brewcomp "--unbrewed --verbose --pinned --versions"
            return
        fi
        ;;
    esac
    __brew_complete_installed
}

_brew_log ()
{
    # if git-completion is loaded, then we complete git-log options
    declare -F _git_log >/dev/null || return
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "
            $__git_log_common_options
            $__git_log_shortlog_options
            $__git_log_gitk_options
            $__git_diff_common_options
            --walk-reflogs --graph --decorate
            --abbrev-commit --oneline --reverse
            "
        return
        ;;
    esac
    __brew_complete_formulae
}

_brew_options ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--all --compact --installed"
        return
        ;;
    esac
    __brew_complete_formulae
}

_brew_outdated ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--quiet"
        return
        ;;
    esac
}

_brew_search ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--debian --fink --macports --opensuse"
        return
        ;;
    esac
}

_brew_uninstall ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--force"
        return
        ;;
    esac
    __brew_complete_installed
}

_brew_update ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--rebase --verbose"
        return
        ;;
    esac
}

_brew_uses ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--installed --recursive"
        return
        ;;
    esac
    __brew_complete_formulae
}

_brew_versions ()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$cur" in
    --*)
        __brewcomp "--compact"
        return
        ;;
    esac
    __brew_complete_formulae
}

_brew ()
{
    local i=1 cmd

    # find the subcommand
    while [[ $i -lt $COMP_CWORD ]]; do
        local s="${COMP_WORDS[i]}"
        case "$s" in
        --*)
            cmd="$s"
            break
            ;;
        -*)
            ;;
        *)
            cmd="$s"
            break
            ;;
        esac
        i=$((++i))
    done

    if [[ $i -eq $COMP_CWORD ]]; then
        local ext=$(\ls -p $(brew --repository)/Library/Contributions/cmd \
                2>/dev/null | sed -e "s/\.rb//g" -e "s/brew-//g" \
                -e "s/.*\///g")
        __brewcomp "
            --cache --cellar --config
            --env --prefix --repository
            audit
            cat
            cleanup
            create
            deps
            diy configure
            doctor
            edit
            fetch
            help
            home
            info abv
            install
            link ln
            list ls
            log
            missing
            options
            outdated
            prune
            pin
            search
            tap
            test
            uninstall remove rm
            unlink
            unpin
            untap
            update
            upgrade
            uses
            versions
            $ext
            "
        return
    fi

    # subcommands have their own completion functions
    case "$cmd" in
    --cache|--cellar|--prefix)  __brew_complete_formulae ;;
    audit|cat|edit|home)        __brew_complete_formulae ;;
    test|unlink)                __brew_complete_installed ;;
    upgrade)                    __brew_complete_outdated ;;
    cleanup)                    _brew_cleanup ;;
    create)                     _brew_create ;;
    deps)                       _brew_deps ;;
    doctor|dr)                  _brew_doctor ;;
    diy|configure)              _brew_diy ;;
    fetch)                      _brew_fetch ;;
    info|abv)                   _brew_info ;;
    install|instal)             _brew_install ;;
    link|ln)                    _brew_link ;;
    list|ls)                    _brew_list ;;
    log)                        _brew_log ;;
    missing)                    __brew_complete_formulae ;;
    options)                    _brew_options ;;
    outdated)                   _brew_outdated ;;
    pin)                        __brew_complete_formulae ;;
    search|-S)                  _brew_search ;;
    tap)                        _brew_complete_tap ;;
    uninstall|remove|rm)        _brew_uninstall ;;
    unpin)                      __brew_complete_formulae ;;
    untap)                      __brew_complete_tapped ;;
    update)                     _brew_update ;;
    uses)                       _brew_uses ;;
    versions)                   _brew_versions ;;
    *)                          ;;
    esac
}

# keep around for compatibility
_brew_to_completion ()
{
    _brew
}

complete -o bashdefault -o default -F _brew brew
