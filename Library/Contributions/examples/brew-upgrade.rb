# Updates all outdated brews
# See: http://github.com/mxcl/homebrew/issues/issue/1324

require 'cmd/outdated'
require 'cmd/install'

Homebrew.install_formulae Homebrew.outdated_brews.map{ |_keg, name, _version| Formula.factory name }
