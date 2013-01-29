#compdef brew

# Brew ZSH completion function
# Drop this somewhere in your $fpath (like /usr/share/zsh/site-functions)
# and rename it _brew
#
# altered from _fink

_brew_all_formulas() {
  formulas=(`brew search`)
}

_brew_installed_formulas() {
  installed_formulas=(`brew list`)
}

_brew_outdated_formulas() {
  outdated_formulas=(`brew outdated`)
}

local -a _1st_arguments
_1st_arguments=(
  'cat:display formula file for a formula'
  'cleanup:uninstall unused and old versions of packages'
  'create:create a new formula'
  'deps:list dependencies and dependants of a formula'
  'doctor:audits your installation for common issues'
  'edit:edit a formula'
  'home:visit the homepage of a formula or the brew project'
  'info:information about a formula'
  'install:install a formula'
  'link:link a formula'
  'list:list files in a formula or not-installed formulas'
  'log:git commit log for a formula'
  'missing:check all installed formuale for missing dependencies.'
  'outdated:list formulas for which a newer version is available'
  'prune:remove dead links'
  'remove:remove a formula'
  'search:search for a formula (/regex/ or string)'
  'server:start a local web app that lets you browse formulas (requires Sinatra)'
  'unlink:unlink a formula'
  'update:freshen up links'
  'upgrade:upgrade outdated formulas'
  'uses:show formulas which depend on a formula'
)

local expl
local -a formulas installed_formulas outdated_formulas

_arguments \
  '(-v)-v[verbose]' \
  '(--cellar)--cellar[brew cellar]' \
  '(--config)--config[brew configuration]' \
  '(--env)--env[brew environment]' \
  '(--repository)--repository[brew repository]' \
  '(--version)--version[version information]' \
  '(--prefix)--prefix[where brew lives on this system]' \
  '(--cache)--cache[brew cache]' \
  '*:: :->subcmds' && return 0

if (( CURRENT == 1 )); then
  _describe -t commands "brew subcommand" _1st_arguments
  return
fi

case "$words[1]" in
  search|-S)
    _arguments \
      '(--macports)--macports[search the macports repository]' \
      '(--fink)--fink[search the fink repository]' ;;
  list|ls)
    _arguments \
      '(--unbrewed)--unbrewed[files in brew --prefix not controlled by brew]' \
      '(--versions)--versions[list all installed versions of a formula]' \
      '1: :->forms' &&  return 0

      if [[ "$state" == forms ]]; then
        _brew_installed_formulas
        _wanted installed_formulas expl 'installed formulas' compadd -a installed_formulas
      fi ;;
  install|home|homepage|log|info|abv|uses|cat|deps|edit|options)
    _brew_all_formulas
    _wanted formulas expl 'all formulas' compadd -a formulas ;;
  remove|rm|uninstall|unlink|cleanup|link|ln)
    _brew_installed_formulas
    _wanted installed_formulas expl 'installed formulas' compadd -a installed_formulas ;;
  upgrade)
    _brew_outdated_formulas
    _wanted outdated_formulas expl 'outdated formulas' compadd -a outdated_formulas ;;
esac
