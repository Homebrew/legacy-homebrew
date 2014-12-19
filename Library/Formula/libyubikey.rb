require 'formula'

class Libyubikey < Formula
  homepage 'http://yubico.github.io/yubico-c/'
  url 'http://yubico.github.io/yubico-c/releases/libyubikey-1.11.tar.gz'
  sha1 'a939abc129ed66af193d979765a8d8ac59ad7c40'

  bottle do
    cellar :any
    revision 1
    sha1 "daad568fcab3dd93b6e04c5f387556d6967c0861" => :yosemite
    sha1 "6180685ff58f83470f2b92ee3537b03c4de6fe96" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
