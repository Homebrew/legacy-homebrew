require 'formula'

class Libosip < Formula
  homepage 'http://www.gnu.org/software/osip/'
  url 'http://ftpmirror.gnu.org/osip/libosip2-3.6.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/osip/libosip2-3.6.0.tar.gz'
  sha1 '6d81be8180a46e045fce676d55913433a5e147c8'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
