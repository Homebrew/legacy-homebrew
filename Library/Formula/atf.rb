require 'formula'

class Atf <Formula
  url 'ftp://ftp.NetBSD.org/pub/NetBSD/misc/jmmv/atf/0.9/atf-0.9.tar.gz'
  homepage 'http://www.netbsd.org/~jmmv/atf/index.html'
  md5 'ec5b2cbbc70b0ced4b46e77c9f0b2a1b'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make install"
  end
end
