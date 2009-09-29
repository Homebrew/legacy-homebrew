require 'brewkit'

class Lynx <Formula
  url 'http://lynx.isc.org/release/lynx2.8.7.tar.bz2'
  homepage 'http://lynx.isc.org/release/'
  md5 '493af4c77ef6761e3f0157cd1be033a0'

  def install
    system "./configure", "--silent",
                          "--prefix=#{prefix}", 
                          "--disable-debug", 
                          "--disable-dependency-tracking",
                          "--disable-echo",
                          "--with-zlib",
                          "--with-bzlib"
    system "make install"
  end
end
