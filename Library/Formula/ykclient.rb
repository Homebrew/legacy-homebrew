require 'formula'

class Ykclient < Formula
  homepage 'http://yubico.github.io/yubico-c-client/'
  url 'http://yubico.github.io/yubico-c-client/releases/ykclient-2.10.tar.gz'
  sha1 'b8818820097bb64395e33dba988aa8bc562ac8fd'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
