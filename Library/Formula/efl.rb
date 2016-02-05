class Efl < Formula
  desc "Libraries for the Enlightenment window manager"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.14.2.tar.gz"
  sha256 "e5699d8183c1540fe45dddaf692254632f9131335e97a09cc313e866a150b42c"
  revision 1

  bottle do
    sha256 "7e97f7173a21a18e7da2ac673eaf9e44fe14b6455e173ae10166154795385355" => :el_capitan
    sha256 "dd6dfce0cab67849f5c51697be0610ee385984710b05a8311955df1829e33ac1" => :yosemite
    sha256 "a516bca511ea00851a41d3294fbfce0352b28eb64239bf499c359fddf37295ec" => :mavericks
  end

  conflicts_with "eina", :because => "efl aggregates formerly distinct libs, one of which is eina"
  conflicts_with "evas", :because => "efl aggregates formerly distinct libs, one of which is evas"
  conflicts_with "eet", :because => "efl aggregates formerly distinct libs, one of which is eet"
  conflicts_with "embryo", :because => "efl aggregates formerly distinct libs, one of which is embryo"

  option "with-docs", "Install development libraries/headers and HTML docs"

  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "pkg-config" => :build
  depends_on :x11 => :optional
  depends_on "openssl"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "webp" => :optional
  depends_on "luajit"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "libtiff"
  depends_on "gstreamer"
  depends_on "gst-plugins-good"
  depends_on "d-bus"
  depends_on "pulseaudio"
  depends_on "bullet"

  needs :cxx11

  def install
    ENV.cxx11
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--enable-cocoa",
            "--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-aba", # There's currently (1.14) no clean profile for Mac OS, so we need to force passing configure
            "--prefix=#{prefix}",
           ]
    args << "--with-x11=none" if build.without? "x11"

    system "./configure", *args
    system "make", "install"
    system "make", "install-doc" if build.with? "docs"
  end

  test do
    system "#{bin}/edje_cc", "-V"
  end
end
