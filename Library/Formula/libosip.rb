require 'formula'

class Libosip < Formula
  homepage 'http://www.gnu.org/software/osip/'
  url 'http://ftpmirror.gnu.org/osip/libosip2-4.1.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/osip/libosip2-4.1.0.tar.gz'
  sha1 '61459c9052ca2f5e77a6936c9b369e2b0602c080'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
