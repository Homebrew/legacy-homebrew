require 'formula'

class Silk < Formula
  homepage 'http://tools.netsa.cert.org/silk/'
  url 'http://tools.netsa.cert.org/releases/silk-3.7.2.tar.gz'
  sha1 '32e73edf764d4c9ce54b9bcf048c13dfd40ec36b'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libfixbuf'
  depends_on 'yaf'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-ipv6",
                          "--enable-data-rootdir=#{var}/silk"
    system "make"
    system "make install"

    (var+"silk").mkpath
  end
end
