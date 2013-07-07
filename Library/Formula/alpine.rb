require 'formula'

class Alpine < Formula
  homepage 'http://www.washington.edu/alpine/'
  url 'ftp://ftp.cac.washington.edu/alpine/alpine-2.00.tar.gz'
  sha1 '363b3aa5d3eb1319e168639fbbc42b033b16f15b'

  # Upstream builds are broken on Snow Leopard due to a hack put in
  # for prior versions of OS X. See:
  # http://trac.macports.org/ticket/20971
  def patches
    "https://trac.macports.org/export/89747/trunk/dports/mail/alpine/files/alpine-osx-10.6.patch"
  end if MacOS.version >= :snow_leopard

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-ssl-include-dir=/usr/include/openssl"
    system "make install"
  end
end
