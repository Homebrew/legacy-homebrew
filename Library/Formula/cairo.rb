require "formula"

class Cairo < Formula
  homepage "http://cairographics.org/"
  url "http://cairographics.org/releases/cairo-1.14.0.tar.xz"
  mirror "http://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/cairo-1.14.0.tar.xz"
  sha256 "2cf5f81432e77ea4359af9dcd0f4faf37d015934501391c311bfd2d19a0134b7"

  bottle do
    revision 1
    sha1 "e2db7a27b4b9ddd78875f8fa1820c756b03ed1ac" => :yosemite
    sha1 "2e975c2003ea16d8186e63c3e59dcc4963227a9e" => :mavericks
    sha1 "b55dd832e2f702cb9685f3b3822b29f7dec0a34a" => :mountain_lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "libpng"
  depends_on "pixman"
  depends_on "glib"
  depends_on :x11 => :recommended

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-gobject=yes
      --enable-svg=yes
      --with-x
    ]

    if build.without? "x11"
      args.delete "--with-x"
      args << "--enable-xlib=no" << "--enable-xlib-xrender=no"
      args << "--enable-quartz-image"
    end

    args << "--enable-xcb=no" if MacOS.version <= :leopard

    system "./configure", *args
    system "make install"
  end
end
