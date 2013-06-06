require 'formula'

class Iniparser < Formula
  homepage 'http://ndevilla.free.fr/iniparser/'
  url 'http://ndevilla.free.fr/iniparser/iniparser-3.1.tar.gz'
  sha1 '41eae7b414cad9cd42ae2c2a64394c10d7ab655e'

  head 'https://github.com/ndevilla/iniparser.git'

  def install
    # Only make the *.a file; the *.so target is useless (and fails).
    system "make", "libiniparser.a", "CC=#{ENV.cc}", "RANLIB=ranlib"
    lib.install 'libiniparser.a'
    include.install Dir['src/*.h']
  end
end
