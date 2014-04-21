require 'formula'

class Wgetpaste < Formula
  homepage 'http://wgetpaste.zlin.dk/'
  url 'http://wgetpaste.zlin.dk/wgetpaste-2.23.tar.bz2'
  sha1 'ccd5b7270e9cc3d3828564a247b1abdec7139cbc'

  def install
    bin.install 'wgetpaste'
  end
end
