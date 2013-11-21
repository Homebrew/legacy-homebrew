require 'formula'

class Wgetpaste < Formula
  homepage 'http://wgetpaste.zlin.dk/'
  url 'http://wgetpaste.zlin.dk/wgetpaste-2.22.tar.bz2'
  sha1 'd0f9c5b997358226b27ff1e22dc023035498d728'

  def install
    bin.install 'wgetpaste'
  end
end
