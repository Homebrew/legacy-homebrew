require 'formula'

class Lynx < Formula
  homepage 'http://lynx.isc.org/release/'
  url 'http://lynx.isc.org/release/lynx2.8.7.tar.bz2'
  sha1 'a34978f7f83cd46bd857cb957faa5a9120458afa'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-echo",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=/usr",
                          "--enable-ipv6"
    system "make install"
  end
end
