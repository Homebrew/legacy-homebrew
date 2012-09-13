require 'formula'

class Arowxx < Formula
  url 'http://arowpp.googlecode.com/files/AROW%2B%2B-0.1.2.tar.gz'
  homepage 'http://code.google.com/p/arowpp/'
  md5 '0231cd596dde6b20fad068bc5c7d423d'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
