require "formula"

class Cairo < Formula
  homepage "http://cairographics.org/"
  url "http://cairographics.org/releases/cairo-1.14.0.tar.xz"
  mirror "http://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/cairo-1.14.0.tar.xz"
  sha256 "2cf5f81432e77ea4359af9dcd0f4faf37d015934501391c311bfd2d19a0134b7"

  bottle do
    revision 2
    sha1 "9030254d5fb307ff28cddfad5a545ec09a64aa32" => :yosemite
    sha1 "811b32fefaa1d57e1ef044a05c1e6d0181554b63" => :mavericks
    sha1 "4d37e02c3ad9136eaf14a98c6a666d5c39a3766d" => :mountain_lion
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
      --enable-tee=yes
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
