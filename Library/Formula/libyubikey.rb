require 'formula'

class Libyubikey < Formula
  homepage 'http://code.google.com/p/yubico-c/'
  url 'http://yubico-c.googlecode.com/files/libyubikey-1.9.tar.gz'
  sha1 '340789bee32d8c0f2f8b2dfdc1b0be428e3140c8'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
