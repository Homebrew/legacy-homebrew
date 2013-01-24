require 'formula'

class Libosip < Formula
  homepage 'http://www.gnu.org/software/osip/'
  url 'http://ftpmirror.gnu.org/osip/libosip2-4.0.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/osip/libosip2-4.0.0.tar.gz'
  sha1 '8b773ad63079ad5e1dc329f73ee8d05ca74ecde4'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
