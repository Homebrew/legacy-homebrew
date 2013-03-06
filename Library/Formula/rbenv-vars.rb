require 'formula'

class RbenvVars < Formula
  homepage 'https://github.com/sstephenson/rbenv-vars'
  url 'https://github.com/sstephenson/rbenv-vars/tarball/v1.2.0'
  sha1 '26a248f5a5f0da0cbb7ad154da8a908341951a10'

  head 'https://github.com/sstephenson/rbenv-vars.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
