require 'formula'

class Depqbf < Formula
  homepage 'http://lonsing.github.io/depqbf/'
  url 'https://github.com/lonsing/depqbf/archive/version-3.01.tar.gz'
  sha1 '7f1dc19f07fc0fa607724d1b7b124d5f2620acee'
  head 'https://github.com/lonsig/depqbf.git'

  def install
    system "make"
    bin.install "depqbf"
  end
end
