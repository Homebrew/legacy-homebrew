require 'formula'

class Libyubikey < Formula
  url 'http://yubico-c.googlecode.com/files/libyubikey-1.7.tar.gz'
  homepage 'http://code.google.com/p/yubico-c/'
  md5 '6468ee9962b45b1daa8be4c040d6a877'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
