require "formula"

class Cairo < Formula
  homepage "http://cairographics.org/"
  url "http://cairographics.org/releases/cairo-1.14.0.tar.xz"
  mirror "http://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/cairo-1.14.0.tar.xz"
  sha256 "2cf5f81432e77ea4359af9dcd0f4faf37d015934501391c311bfd2d19a0134b7"

  bottle do
    sha1 "3ec58f58f8b839c77875c726f955f22e0c3a401d" => :yosemite
    sha1 "67eaec481abb67adbaf572c97b57b05bb0131f23" => :mavericks
    sha1 "61992cb13847bdb5fa92a506f6d28166236c3964" => :mountain_lion
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
