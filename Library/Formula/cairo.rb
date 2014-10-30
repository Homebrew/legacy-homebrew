require "formula"

# Use a mirror because of:
# http://lists.cairographics.org/archives/cairo/2012-September/023454.html

class Cairo < Formula
  homepage "http://cairographics.org/"
  url "http://cairographics.org/releases/cairo-1.14.0.tar.xz"
  mirror "https://downloads.sourceforge.net/project/machomebrew/mirror/cairo-1.14.0.tar.xz"
  sha256 "2cf5f81432e77ea4359af9dcd0f4faf37d015934501391c311bfd2d19a0134b7"

  bottle do
    sha1 "25b504ff3e601cc87d5f64b2bcc04712aef9ba62" => :yosemite
    sha1 "e111154f2b17cdab98ee0606e286761e72ee019c" => :mavericks
    sha1 "14926972549bc24365481a627ed8e9d6d02bd2c5" => :mountain_lion
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
