require 'formula'

class BrewGrowl < Formula
  url 'https://github.com/secondplanet/brew-growl/tarball/master'
  homepage 'https://github.com/secondplanet/brew-pip'
  version '0.0.1'
  md5 '87faf912d41f3e9aef84e870629d380c'

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
