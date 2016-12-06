require 'formula'

class RbenvInstall < Formula
  url 'https://github.com/sj26/rbenv-install.git', :using => :git
  homepage 'https://github.com/sj26/rbenv-install'
  version 'git'

  depends_on 'rbenv'

  def install
    rbenv = Formula.factory 'rbenv'

    # Copy it all in
    prefix.install Dir['*']
  end
end
