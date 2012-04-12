require 'formula'

class Atf < Formula
  url 'ftp://ftp.NetBSD.org/pub/NetBSD/misc/jmmv/atf/0.14/atf-0.14.tar.gz'
  homepage 'http://www.netbsd.org/~jmmv/atf/index.html'
  sha256 'bfdd26321f3e4d62254277a646b2df7ce113369c4a79090b8d77c2e9979eba7a'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make install"
  end
end
