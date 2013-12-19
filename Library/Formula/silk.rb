require 'formula'

class Silk < Formula
  homepage 'http://tools.netsa.cert.org/silk/'
  url 'http://tools.netsa.cert.org/releases/silk-3.8.0.tar.gz'
  sha1 '5f3887fcc7147cc5a86cdd6ffa73854b93eb24d0'

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
