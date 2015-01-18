class Libyubikey < Formula
  homepage "http://yubico.github.io/yubico-c/"
  url "https://developers.yubico.com/yubico-c/Releases/libyubikey-1.12.tar.gz"
  sha1 "6a73d548e61f0b622a9447917f03c78686ab386d"

  bottle do
    cellar :any
    sha1 "220ecad49555d9b8fb07f27c45114d22d6d2c07a" => :yosemite
    sha1 "554afeb53a8ea2cd5e94da98dee63107cb4f555a" => :mavericks
    sha1 "131b7d2a109089877855f53eaf7784fe480afc8d" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
