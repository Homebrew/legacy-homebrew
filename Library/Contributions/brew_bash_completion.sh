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
# and bash-completion will source it automatically.
#
# The __brew_ps1() function can be used to annotate your PS1 with
# Homebrew debugging information; it behaves similarly to the __git_ps1()
# function provided by the git's bash completion script.
#
# For example, the prompt string
#
#     PS1='\u@\h \W $(__brew_ps1 "(%s)") $'
#
# would result in a prompt like
#
#    user@hostname cwd $
#
# but if you are currently engaged in an interactive or debug install,
# (i.e., you invoked `brew install` with either '-i' or '-d'), then the
# prompt would look like
#
#     user@hostname cwd (<formula_name>|DEBUG) $
#
# You can customize the output string, e.g. $(__brew_ps1 "[%s]") would
# output "[<formula_name>|DEBUG]". The default (if you do not provide a
# format argument) is to print "(<formula_name>|DEBUG)" prefixed with a
# single space.

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
	local ff=$(\ls $(brew --repository)/Library/Formula 2>/dev/null | sed 's/\.rb//g')
        local af=$(\ls $(brew --repository)/Library/Aliases 2>/dev/null | sed 's/\.rb//g')
        COMPREPLY=($(compgen -W "$ff $af" -- "$cur"))
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
		__brewcomp "--autotools --cmake --no-fetch"
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
	case "$cur" in
	--*)
		__brewcomp "--deps --force --HEAD"
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
				$(brew options --compact "$prv")
				"
		fi
		return
		;;
	esac
	__brew_complete_formulae
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
		elif __brewcomp_words_include "--versions"; then
			return
		else
			__brewcomp "--unbrewed --verbose --versions"
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
		__brewcomp "--fink --macports"
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
		__brewcomp "--installed"
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

__brew_ps1 ()
{
    [[ -n $HOMEBREW_DEBUG_INSTALL ]] &&
    printf "${1:- (%s)}" "$HOMEBREW_DEBUG_INSTALL|DEBUG"
}

_brew ()
{
	local i=1 cmd

	# find the subcommand
	while [[ $i -lt $COMP_CWORD ]]; do
		local s="${COMP_WORDS[i]}"
		case "$s" in
		--*) 	cmd="$s"
			break
			;;
		-*)	;;
		*) 	cmd="$s"
			break
			;;
		esac
		i=$((++i))
	done

	if [[ $i -eq $COMP_CWORD ]]; then
		local ext=$(\ls $(brew --repository)/Library/Contributions/examples \
			    2>/dev/null | sed -e "s/\.rb//g" -e "s/brew-//g")
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
			options
			outdated
			prune
			search
			test
			uninstall remove rm
			unlink
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
	--cache|--cellar|--prefix)
				__brew_complete_formulae ;;
	audit|cat|edit|home)	__brew_complete_formulae ;;
	link|ln|test|unlink)	__brew_complete_installed ;;
	upgrade)		__brew_complete_outdated ;;
	cleanup)		_brew_cleanup ;;
	create)			_brew_create ;;
	deps)			_brew_deps ;;
	diy|configure)		_brew_diy ;;
	fetch)			_brew_fetch ;;
	info|abv)		_brew_info ;;
	install)		_brew_install ;;
	list|ls)		_brew_list ;;
	log)			_brew_log ;;
	options)		_brew_options ;;
	outdated)		_brew_outdated ;;
	search|-S)		_brew_search ;;
	uninstall|remove|rm) 	_brew_uninstall ;;
	update)			_brew_update ;;
	uses)			_brew_uses ;;
	versions)		_brew_versions ;;
	*)			;;
	esac
}

# keep around for compatibility
_brew_to_completion ()
{
	_brew
}

complete -o bashdefault -o default -F _brew brew
