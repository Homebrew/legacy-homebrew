require "formula"

class Harfbuzz < Formula
  homepage "http://www.freedesktop.org/wiki/Software/HarfBuzz"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.35.tar.bz2"
  sha256 "0aa1a8aba6f502321cf6fef3c9d2c73dde48389c5ed1d3615a7691944c2a06ed"
  revision 1

  bottle do
    cellar :any
    sha1 "79995bf3420a4425caa1e6c77c6d7afecb2a031f" => :mavericks
    sha1 "1036fa82be4cec7360c893d7c11ff4db1f22bbce" => :mountain_lion
    sha1 "7576887f31f59f9d4044d81251a41377b9144fe8" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "cairo"
  depends_on "icu4c" => :recommended
  depends_on "freetype"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-icu" if build.with? "icu4c"
    system "./configure", *args
    system "make install"
  end
end
