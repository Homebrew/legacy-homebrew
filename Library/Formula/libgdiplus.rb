require "formula"

class Libgdiplus < Formula
  homepage "https://github.com/mono/libgdiplus"
  url "https://github.com/mono/libgdiplus/archive/3.8.tar.gz"
  sha1 "4dee0aeee34e1188bb7f5a44b7bf10e274a62b5a"
  head "https://github.com/mono/libgdiplus.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cairo"
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
