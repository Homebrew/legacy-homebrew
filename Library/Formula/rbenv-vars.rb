require 'formula'

class RbenvVars < Formula
  homepage 'https://github.com/sstephenson/rbenv-vars'
  url 'https://github.com/sstephenson/rbenv-vars/tarball/v1.1.0'
  sha1 '40d57e4a1f64ef03efbf6fd5a15ef637d6a5755e'

  head 'https://github.com/sstephenson/rbenv-vars.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
