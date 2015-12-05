class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "http://poppler.freedesktop.org"
  url "http://poppler.freedesktop.org/poppler-0.37.0.tar.xz"
  sha256 "b89f9c5eae3bbb1046b0f767714afd75eca102a0406a3a30856778d42a685bee"

  bottle do
    sha256 "82185b06f6cd82b6e84f5a8e999a76222a103590bd1aaaf811f24c6985f6db5c" => :el_capitan
    sha256 "39e85a3e31e1eb53051939e83be74a1f8edc957384479ea4b0fff75585bc754e" => :yosemite
    sha256 "be4351a0bb787d2571be314091f8fd8c1a6cac80f3dd4360f63dbf3781f8e676" => :mavericks
  end

  option "with-qt", "Build Qt backend"
  option "with-qt5", "Build Qt5 backend"
  option "with-little-cms2", "Use color management system"

  deprecated_option "with-qt4" => "with-qt"
  deprecated_option "with-lcms2" => "with-little-cms2"

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"

  depends_on "qt" => :optional
  depends_on "qt5" => :optional
  depends_on "little-cms2" => :optional

  conflicts_with "pdftohtml", :because => "both install `pdftohtml` binaries"

  resource "font-data" do
    url "http://poppler.freedesktop.org/poppler-data-0.4.7.tar.gz"
    sha256 "e752b0d88a7aba54574152143e7bf76436a7ef51977c55d6bd9a48dccde3a7de"
  end

  def install
    ENV["LIBOPENJPEG_CFLAGS"] = "-I#{Formula["openjpeg"].opt_include}/openjpeg-1.5"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-xpdf-headers
      --enable-poppler-glib
      --disable-gtk-test
      --enable-introspection=yes
    ]

    if build.with?("qt") && build.with?("qt5")
      raise "poppler: --with-qt and --with-qt5 cannot be used at the same time"
    elsif build.with? "qt"
      args << "--enable-poppler-qt4"
    elsif build.with? "qt5"
      args << "--enable-poppler-qt5"
    else
      args << "--disable-poppler-qt4" << "--disable-poppler-qt5"
    end

    args << "--enable-cms=lcms2" if build.with? "little-cms2"

    system "./configure", *args
    system "make", "install"
    resource("font-data").stage do
      system "make", "install", "prefix=#{prefix}"
    end
  end

  test do
    system "#{bin}/pdfinfo", test_fixtures("test.pdf")
  end
end
