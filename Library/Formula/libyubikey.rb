require 'formula'

class Libyubikey < Formula
  homepage 'http://code.google.com/p/yubico-c/'
  url 'http://yubico-c.googlecode.com/files/libyubikey-1.10.tar.gz'
  sha1 '796c24f6dd642d25bab782947b134ed1c79aecde'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
