require 'formula'

class Ykclient < Formula
  url 'http://yubico-c-client.googlecode.com/files/ykclient-2.8.tar.gz'
  homepage 'http://code.google.com/p/yubico-c-client/'
  sha1 '91aefae12d7e13360d8c03ccd66ef1d26d1b04f9'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
