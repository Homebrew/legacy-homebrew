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
                          "--enable-default-colors",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=#{MacOS.sdk_path}/usr",
                          "--enable-ipv6"
    system "make install"
  end

  test do
    system "#{bin}/lynx", '-dump', 'http://checkip.dyndns.org'
  end
end
