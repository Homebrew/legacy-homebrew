require 'formula'

class Depqbf < Formula
  homepage 'http://lonsing.github.io/depqbf/'
  url 'https://github.com/lonsing/depqbf/archive/version-2.0.tar.gz'
  sha1 '86684df3d135847189a0312f45ba69e16bcd76ac'
  head 'https://github.com/lonsig/depqbf.git'

  def install
    system "make"
    bin.install "depqbf"
  end
end
