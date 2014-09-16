require "formula"

class Libbluray < Formula
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "ftp://ftp.videolan.org/pub/videolan/libbluray/0.6.2/libbluray-0.6.2.tar.bz2"
  sha1 "a1ab8c8c9310680fb1fe6a58f9fc5430613600fe"

  bottle do
    cellar :any
    sha1 "a8d92a21ac562627b5f3675d3873a1ab52739964" => :mavericks
    sha1 "7f20e2e75ee36646ee965167f457dbe4da2a715a" => :mountain_lion
    sha1 "fe040200d7ad44edc83f6e0490c7905579b7d2f6" => :lion
  end

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
