require 'formula'

class RbenvGemset < Formula
  homepage 'https://github.com/jf/rbenv-gemset'
  url 'https://github.com/jf/rbenv-gemset/archive/v0.5.7.tar.gz'
  sha1 '9c7ab9c6a3b8599902dd8713ee4f4c8110a1e6a3'

  head 'https://github.com/jf/rbenv-gemset.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
