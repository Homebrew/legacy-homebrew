require "formula"

class Mmseg < Formula
  homepage "https://github.com/RobinQu/mmseg/"
  url "https://github.com/RobinQu/mmseg/archive/3.2.15.tar.gz"
  sha1 "bf58446b10becee25512575664db060455d592a4"

  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "m4" => :build
  depends_on "automake" => :build

  def install
    ENV.deparallelize
    system "aclocal"
    system "glibtoolize", "--copy", "--force", "--ltdl"
    system "autoreconf", "-i", "-f"
    system "automake", "--a"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
