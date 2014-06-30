require "formula"

class Libfixbuf < Formula
  homepage "http://tools.netsa.cert.org/fixbuf/"
  url "http://tools.netsa.cert.org/releases/libfixbuf-1.5.0.tar.gz"
  sha1 "6e77c2ec1ee32514454ad1fff6494265c583e72c"

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
