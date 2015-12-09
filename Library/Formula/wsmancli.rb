class Wsmancli < Formula
  desc "Openwsman command-line client"
  homepage "https://github.com/Openwsman/wsmancli"
  url "https://github.com/Openwsman/wsmancli/archive/v2.3.1.tar.gz"
  sha256 "f8e71b842c506885f63d80d7cd49bb95989043b1305b95c1fbda27ca2df9528b"

  bottle do
    cellar :any
    sha256 "0f39a0bdfb252363b5fa64ddf6e412d3ed8c6b81d206d29c3fa94b702c38877c" => :yosemite
    sha256 "e965cf5411b4f8c6a4d39729a32dc0b58bd03984b83ee361a4046a21cc212d21" => :mavericks
    sha256 "11f1296fd8079b931a5e316c42ba7071c169f57bc9af88975eec36b8d47dc0d1" => :mountain_lion
  end

  depends_on "openwsman"
  depends_on "autoconf"   => :build
  depends_on "automake"   => :build
  depends_on "libtool"    => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wsman", "-q"
  end
end
