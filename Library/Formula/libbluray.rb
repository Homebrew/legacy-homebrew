require "formula"

class Libbluray < Formula
  homepage "http://www.videolan.org/developers/libbluray.html"
  url "ftp://ftp.videolan.org/pub/videolan/libbluray/0.6.0/libbluray-0.6.0.tar.bz2"
  sha1 "2249e72ea50f43a1864c7f9658e13403ca3270f7"

  head do
    url "git://git.videolan.org/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype" => :recommended

  def install
    # https://mailman.videolan.org/pipermail/libbluray-devel/2014-April/001401.html
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    ENV.libxml2

    args = %W[--prefix=#{prefix} --disable-dependency-tracking]
    args << "--without-freetype" if build.without? "freetype"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make install"
  end
end
