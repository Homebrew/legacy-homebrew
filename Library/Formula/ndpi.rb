require "formula"

class Ndpi < Formula
  homepage "http://www.ntop.org/products/ndpi/"
  url "https://downloads.sourceforge.net/project/ntop/nDPI/libndpi-1.5.1.tar.gz"
  sha1 "0a6ed585545ab6611f3f0ac9efd9eb36bb5481dd"

  bottle do
    cellar :any
    sha1 "81793f54b751d220e7f2bd2389f48e975a84c153" => :mavericks
    sha1 "2384472ca14acbfa1e8be322f8ed0cd00b7cf608" => :mountain_lion
    sha1 "b5e612452ecad91acecb4692b2b7fd24ada70b21" => :lion
  end

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
    system "#{bin}/ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
