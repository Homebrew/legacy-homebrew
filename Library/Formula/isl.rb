require 'formula'

class Isl < Formula
  homepage 'http://www.kotnet.org/~skimo/isl/'
  url 'http://ftp.de.debian.org/debian/pool/main/i/isl/isl_0.11.2.orig.tar.bz2'
  mirror 'ftp://ftp.linux.student.kuleuven.be/pub/people/skimo/isl/isl-0.11.2.tar.bz2'
  mirror 'http://www.kotnet.org/~skimo/isl/isl-0.11.2.tar.bz2'
  sha1 'ca2c93a58e899379d39f2956b2299c62e3975018'

  head 'http://repo.or.cz/w/isl.git'

  depends_on 'gmp'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end
end
