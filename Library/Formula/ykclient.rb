require 'formula'

class Ykclient < Formula
  url 'http://yubico-c-client.googlecode.com/files/ykclient-2.3.tar.gz'
  homepage 'http://code.google.com/p/yubico-c-client/'
  md5 '7de70fb19e1a1857689afaec74def7fb'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
