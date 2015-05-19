require 'formula'

class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage 'http://ndevilla.free.fr/iniparser/'
  head 'https://github.com/ndevilla/iniparser.git'
  url 'http://ndevilla.free.fr/iniparser/iniparser-3.1.tar.gz'
  sha1 '41eae7b414cad9cd42ae2c2a64394c10d7ab655e'

  conflicts_with 'fastbit', :because => 'Both install `include/dictionary.h`'

  def install
    # Only make the *.a file; the *.so target is useless (and fails).
    system "make", "libiniparser.a", "CC=#{ENV.cc}", "RANLIB=ranlib"
    lib.install 'libiniparser.a'
    include.install Dir['src/*.h']
  end
end
