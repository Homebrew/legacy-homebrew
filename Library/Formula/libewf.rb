require 'formula'

class Libewf < Formula
  homepage 'http://code.google.com/p/libewf/'
  url 'http://libewf.googlecode.com/files/libewf-20130303.tar.gz'
  sha1 '99e86eb71b7a1203c9b95141a5f10ff2c22e35c1'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
