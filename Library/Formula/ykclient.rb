require 'formula'

class Ykclient < Formula
  homepage 'http://code.google.com/p/yubico-c-client/'
  url 'http://yubico-c-client.googlecode.com/files/ykclient-2.9.tar.gz'
  sha1 'b3f8e0fffec6fa078375a4adee0f7cd968ea27f0'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
