require 'formula'

class Ykclient < Formula
  url 'http://yubico-c-client.googlecode.com/files/ykclient-2.7.tar.gz'
  homepage 'http://code.google.com/p/yubico-c-client/'
  md5 'ffaf492498d8d57e87fbbe355d438a91'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
