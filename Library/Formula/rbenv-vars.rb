require 'formula'

class RbenvVars < Formula
  head 'https://github.com/sstephenson/rbenv-vars.git'
  homepage 'https://github.com/sstephenson/rbenv-vars'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
