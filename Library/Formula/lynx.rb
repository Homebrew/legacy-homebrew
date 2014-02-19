require 'formula'

class Lynx < Formula
  homepage 'http://lynx.isc.org/release/'
  url 'http://lynx.isc.org/lynx2.8.8/lynx2.8.8.tar.bz2'
  sha1 'cc925355db7a8631677e9da6bb632553da9744a0'

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
