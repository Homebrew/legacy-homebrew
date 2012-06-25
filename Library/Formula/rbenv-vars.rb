require 'formula'

class RbenvVars < Formula
  url 'https://github.com/sstephenson/rbenv-vars/tarball/v1.1.0'
  homepage 'https://github.com/sstephenson/rbenv-vars'
  md5 '081dbee21141ebeee0cc88041855c0e3'

  head 'https://github.com/sstephenson/rbenv-vars.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
