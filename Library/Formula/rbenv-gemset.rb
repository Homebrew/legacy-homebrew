require 'formula'

class RbenvGemset < Formula
  homepage 'https://github.com/jf/rbenv-gemset'
  url 'https://github.com/jf/rbenv-gemset/archive/v0.4.0.tar.gz'
  sha1 '4363b7995d0a3c58ca6c751f907d015bfacc57cf'

  head 'https://github.com/jf/rbenv-gemset.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
