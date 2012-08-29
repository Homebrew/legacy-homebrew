require 'formula'

class Libzip < Formula
  url 'http://www.nih.at/libzip/libzip-0.10.1.tar.bz2'
  homepage 'http://www.nih.at/libzip/'
  md5 'd3e933ae049204badccf605f20aaecde'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}",
                          "CXX=#{ENV.cxx}", "CXXFLAGS=#{ENV.cflags}"
    system "make install"
  end
end
