require 'formula'

class RbenvGemset < Formula
  homepage 'https://github.com/jf/rbenv-gemset'
  url 'https://github.com/jf/rbenv-gemset/archive/v0.5.8.tar.gz'
  sha1 'bd06efff2fcfaeb47bd32dc1658e4aae5d8a0619'

  head 'https://github.com/jf/rbenv-gemset.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
