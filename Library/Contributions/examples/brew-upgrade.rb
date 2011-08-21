# Updates all outdated brews
# See: http://github.com/mxcl/homebrew/issues/issue/1324

require 'cmd/outdated'
require 'cmd/install'


if ARGV.named.empty?  
  # Upgrade all outdated formulae if none are specified on the command line
  Homebrew.install_formulae Homebrew.outdated_brews.map{ |_keg, name, _version| Formula.factory name }

else
  # Upgrade only specified formulae
  (ARGV.formulae & Homebrew.outdated_brews).each do |f|
    Hombrew.install_formula f
  end

  # Notify anything already up-to-date
  unless (ARGV.formulae - Homebrew.outdated_brews).empty?
    ohai "Already up-to-date:", (ARGV.formulae - Homebrew.outdated_brews)
  end
  
end