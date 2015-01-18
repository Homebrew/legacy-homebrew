class Libyubikey < Formula
  homepage "http://yubico.github.io/yubico-c/"
  url "https://developers.yubico.com/yubico-c/Releases/libyubikey-1.12.tar.gz"
  sha1 "6a73d548e61f0b622a9447917f03c78686ab386d"

  bottle do
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
