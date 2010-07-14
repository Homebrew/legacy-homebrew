require 'formula'

class Lynx <Formula
  url 'http://lynx.isc.org/release/lynx2.8.7.tar.bz2'
  homepage 'http://lynx.isc.org/release/'
  md5 'cb936aef812e4e463ab86cbbe14d4db9'

  def install
    system "./configure", "--prefix=#{prefix}", 
                          "--mandir=#{man}",
                          "--disable-debug", 
                          "--disable-dependency-tracking",
                          "--disable-echo",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl",
                          "--enable-ipv6"
    system "make install"
  end
end
