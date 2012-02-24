require 'formula'

class Objconv < Formula
  homepage 'http://www.agner.org/optimize/'
  url 'https://github.com/downloads/vertis/objconv/objconv-2.12.tar.gz'
  md5 'c50b92d6e11dcc5ad9805e969706d0b7' 

  def install
    system "#{ENV.cxx} -o objconv -O2 src/*.cpp"
    bin.install 'objconv'
  end

  def test
    system "objconv -h"
  end
end
