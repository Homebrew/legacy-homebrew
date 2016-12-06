require 'formula'

class Ninja < Formula
  url 'https://github.com/martine/ninja/tarball/release-120508'
  homepage 'http://martine.github.com/ninja/'
  md5 '0789f8f78b98d5bc80404492b90f79ec'
  version '120508'

  def install
    system "./bootstrap.py"
    bin.install "ninja"
  end
end
