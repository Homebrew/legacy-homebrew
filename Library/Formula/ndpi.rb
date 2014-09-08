require "formula"

class Ndpi < Formula
  homepage "http://www.ntop.org/products/ndpi/"
  url "https://downloads.sourceforge.net/project/ntop/nDPI/libndpi-1.5.1.tar.gz"
  sha1 "0a6ed585545ab6611f3f0ac9efd9eb36bb5481dd"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-c"

  def install
    system "./configure","--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    test_pcap = HOMEBREW_LIBRARY/"Homebrew/test/fixtures/test.pcap"
    system "#{bin}/ndpiReader", "-i", test_pcap
  end
end
