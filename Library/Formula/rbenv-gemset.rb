require 'formula'

class RbenvGemset < Formula
  homepage 'https://github.com/jamis/rbenv-gemset'
  url 'https://github.com/jamis/rbenv-gemset/tarball/v0.3.0'
  sha1 '52e058e43a4a1395c3fe923365cee53d0977c41a'

  head 'https://github.com/jamis/rbenv-gemset.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
