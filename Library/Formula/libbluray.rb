require "formula"

class Libbluray < Formula
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "ftp://ftp.videolan.org/pub/videolan/libbluray/0.6.2/libbluray-0.6.2.tar.bz2"
  sha1 "a1ab8c8c9310680fb1fe6a58f9fc5430613600fe"

  bottle do
    cellar :any
    sha1 "1279469297c7bc2c71d049c64dbd7ef421be69ca" => :mavericks
    sha1 "c6fa0e3c42f874f096305663f1775faae9fa54d2" => :mountain_lion
    sha1 "2b5429190d5471b58d4f6fcc44ea02c88081bf71" => :lion
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
