require 'formula'

class Dircproxy < Formula
  homepage 'http://code.google.com/p/dircproxy/'
  url 'http://dircproxy.googlecode.com/files/dircproxy-1.2.0-RC1.tar.gz'
  sha1 '7dc4b3aa2e10222f74e280de69c41f571335a96b'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-ssl"
    system "make install"
  end
end
