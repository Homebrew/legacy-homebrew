require 'formula'

class Libyubikey < Formula
  homepage 'http://yubico.github.io/yubico-c/'
  url 'http://yubico.github.io/yubico-c/releases/libyubikey-1.11.tar.gz'
  sha1 'a939abc129ed66af193d979765a8d8ac59ad7c40'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
