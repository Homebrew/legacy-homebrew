class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-1.7.0.tar.gz"
  sha256 "0cb7e29ad5ae9d0186718f325ec12786222794cc25adc2e28707322112e15a3d"

  bottle do
    cellar :any
    sha256 "3711773aba1acc3212b07ba5029e6368a7f22306609da9f7e9f3fae0e21a48dc" => :yosemite
    sha256 "e67dbd4fa9c4f77f840adfeb0e85d300a380429f843f7d82d1e7b1b902b3437a" => :mavericks
    sha256 "5e4ec8f9f0068350f26b8a578621e65506adac352d929d0b3bf007aa7f2c9b08" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
