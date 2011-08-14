require 'formula'

class RbenvGemset < Formula
  url 'https://github.com/jamis/rbenv-gemset.git', :using => :git
  homepage 'https://github.com/jamis/rbenv-gemset'
  version 'git'

  depends_on 'rbenv'

  def install
    rbenv = Formula.factory 'rbenv'

    # Copy it all in
    prefix.install Dir['*']

    # rbenv-gemset installs scripts which need to go into the rbenv keg
    system bin / 'rbenv-gemset', 'install', '-g'
    system 'cp', '-r', '/tmp/rbenv.d', rbenv.prefix + 'rbenv.d'
    system 'rm', '-r', '/tmp/rbenv.d'
  end
end
