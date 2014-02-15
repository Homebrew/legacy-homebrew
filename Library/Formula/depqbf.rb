require 'formula'

class Depqbf < Formula
  homepage 'http://lonsing.github.io/depqbf/'
  url 'https://github.com/lonsing/depqbf/archive/version-3.0.tar.gz'
  sha1 '4dbce430731ba0424b24f3960b932fe2984eb452'
  head 'https://github.com/lonsig/depqbf.git'

  def install
    system "make"
    bin.install "depqbf"
  end
end
