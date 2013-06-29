require 'formula'

class RbenvVars < Formula
  homepage 'https://github.com/sstephenson/rbenv-vars'
  url 'https://github.com/sstephenson/rbenv-vars/archive/v1.2.0.tar.gz'
  sha1 '8953cecac154fac96dc1e68b54d66a4c8b569e08'

  head 'https://github.com/sstephenson/rbenv-vars.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
