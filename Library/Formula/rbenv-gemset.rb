require 'formula'

class RbenvGemset < Formula
  homepage 'https://github.com/jf/rbenv-gemset'
  url 'https://github.com/jf/rbenv-gemset/archive/v0.5.3.tar.gz'
  sha1 '5fc4cee421ae1711a60ed8fb861ee2704211057b'

  head 'https://github.com/jf/rbenv-gemset.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
