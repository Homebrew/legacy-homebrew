require 'formula'

class Libyubikey < Formula
  homepage 'http://yubico.github.io/yubico-c/'
  url 'http://yubico.github.io/yubico-c/releases/libyubikey-1.10.tar.gz'
  sha1 '796c24f6dd642d25bab782947b134ed1c79aecde'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
