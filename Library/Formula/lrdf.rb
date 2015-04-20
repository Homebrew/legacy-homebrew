require 'formula'

class Lrdf < Formula
  homepage 'https://github.com/swh/LRDF'
  url 'https://github.com/swh/LRDF/archive/0.5.0.tar.gz'
  sha1 'f44889937a70581c737976687f81cee71f92032f'

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "raptor"

  def install
    system "glibtoolize"
    system "aclocal", "-I", "m4"
    system "autoconf"
    system "automake", "-a", "-c"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
