class Efl < Formula
  desc "Libraries for the Enlightenment window manager"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.14.0.tar.gz"
  sha256 "30a8a239449e0d068a39787b5a4769dd26ddf0476f58f094c85e65b108086269"

  bottle do
    sha256 "6fc05ee275321d4d2c883a4f7b19b6144d4e02e545d35a88ec8ebbae3ba8f5d2" => :yosemite
    sha256 "b8dbeab7156541c3f5538d8af78bff8d4fa96e372985e9ecc9e081f469fa2d48" => :mavericks
    sha256 "c1f2f8cdfe2414f9248d1992edc7d9cfa3c78b51ffdaaaec44c109cd2ba0a982" => :mountain_lion
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
            "--prefix=#{prefix}"]
    args << "--with-x11=none" if build.without? "x11"

    system "./configure", *args
    system "make", "install"
    system "make", "install-doc" if build.with? "docs"
  end

  test do
    system "#{bin}/edje_cc", "-V"
  end
end
