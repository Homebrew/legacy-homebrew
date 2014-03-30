require 'formula'

class Lynx < Formula
  homepage 'http://lynx.isc.org/release/'
  url 'http://lynx.isc.org/current/lynx2.8.8rel.2.tar.bz2'
  version '2.8.8rel.2'
  sha1 '65bbf95627c88723bbb5880155e5fe01c2753d0c'

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-echo",
                          "--enable-default-colors",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--enable-ipv6"
    system "make install"
  end

  test do
    system "#{bin}/lynx", '-dump', 'http://checkip.dyndns.org'
  end
end
