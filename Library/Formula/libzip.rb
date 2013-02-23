require 'formula'

class Libzip < Formula
  homepage 'http://www.nih.at/libzip/'
  url 'http://www.nih.at/libzip/libzip-0.10.1.tar.bz2'
  sha1 '04be811a1919e1063a1f5210671181b7b5416d45'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make install"
  end
end
