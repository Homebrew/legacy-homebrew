require 'formula'

class RbenvUse < Formula
  homepage 'https://github.com/rkh/rbenv-use'
  url 'https://github.com/rkh/rbenv-use/archive/bb3294.tar.gz'
  sha1 'b8396084fa810e7754aea9a3c01ae288420e5932'

  depends_on 'rbenv'
  depends_on 'rbenv-whatis'

  def install
    prefix.install Dir['*']
  end
end
