require 'formula'

class Libyubikey < Formula
  url 'http://yubico-c.googlecode.com/files/libyubikey-1.8.tar.gz'
  homepage 'http://code.google.com/p/yubico-c/'
  md5 '373d59ded8d533ca12173a022a74f8ff'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
