require "formula"

class Libuninameslist < Formula
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/archive/0.4.20140731.tar.gz"
  sha1 "73464796bbec6f350826f985ce5691738dc5e11c"

  head "https://github.com/fontforge/libuninameslist.git"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "automake", "--foreign"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
