require "formula"

class Ndpi < Formula
  homepage "http://www.ntop.org/products/ndpi/"
  url "https://downloads.sourceforge.net/project/ntop/nDPI/libndpi-1.5.1.tar.gz"
  sha1 "2932c2d1a50fb4cee39edda78a88df953d996d2b"

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
