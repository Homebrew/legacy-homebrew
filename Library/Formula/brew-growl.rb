require 'formula'

class BrewGrowl < Formula
  url 'git://github.com/secondplanet/brew-growl'
  homepage 'https://github.com/secondplanet/brew-growl'
  version '0.0.1'

  def install
    inreplace 'bin/brew-growl', /^BREW_PREFIX = '.*'$/, "BREW_PREFIX = '#{HOMEBREW_PREFIX}'"
    bin.install 'bin/brew-growl'
  end

  def caveats; <<-EOS
To turn on brew growl,

  brew growl on

Add the following to your ~/.zshrc or ~/.bashrc:

  source ~/.brew-growl

To switch of later,

  brew growl on
    EOS
  end
end
