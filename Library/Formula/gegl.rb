require "formula"

class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "http://www.gegl.org/"

  stable do
    # Use Debian because the official URL is unreliable.
    url "https://mirrors.kernel.org/debian/pool/main/g/gegl/gegl_0.2.0.orig.tar.bz2"
    mirror "ftp://ftp.gimp.org/pub/gegl/0.2/gegl-0.2.0.tar.bz2"
    sha1 "764cc66cb3c7b261b8fc18a6268a0e264a91d573"
  end

  bottle do
    sha1 "df1f74de4563aa8c1de86cf03cf265c42e923c41" => :yosemite
    sha1 "3c395d3cfaf0e423e7e072c13fe0d51d7829d8a5" => :mavericks
    sha1 "93133f696a63fb0e865d51251b309ea327ab2ce7" => :mountain_lion
  end

  head do
    # Use the Github mirror because official git unreliable.
    url "https://github.com/GNOME/gegl.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "babl"
  depends_on "glib"
  depends_on "gettext"
  depends_on "libpng"
  depends_on "jpeg" => :optional
  depends_on "lua" => :optional
  depends_on "cairo" => :optional
  depends_on "pango" => :optional
  depends_on "librsvg" => :optional
  depends_on "sdl" => :optional

  def install
    # ./configure breaks when optimization is enabled with llvm
    ENV.no_optimization if ENV.compiler == :llvm

    argv = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-docs
    ]

    if build.universal?
      ENV.universal_binary
      # ffmpeg's formula is currently not universal-enabled
      argv << "--without-libavformat"

      opoo "Compilation may fail at gegl-cpuaccel.c using gcc for a universal build" if ENV.compiler == :gcc
    end

    system "./autogen.sh" if build.head?
    system "./configure", *argv
    system "make", "install"
  end
end
