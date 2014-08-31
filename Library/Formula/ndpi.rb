require "formula"

class Ndpi < Formula
  homepage "http://www.ntop.org/products/ndpi/"
  url "https://downloads.sourceforge.net/project/ntop/nDPI/libndpi-1.5.0_r8115.tar.gz"
  sha1 "9fbb97dd3de35670c8f527ac3ccdb1aa50a4da70"
  version "1.5.0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  def install
    system "./configure","--prefix=#{prefix}"
    system "make"
    system "make","install"
  end

  test do
    system "#{bin}/ndpiReader","-h"
  end

end
