class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-0.41.0.tar.xz"
  sha256 "420abaab63caed9e1ee28964a0ba216d1979506726164bc99ad5ade289192a1b"

  bottle do
    sha256 "cc7172f9b672b09f52140463ac3ac574f79dc83015e2d927cf3abe8b225da6a3" => :el_capitan
    sha256 "3771644309b386fd69a6678167b73849d718624b7a64c5bdf06e5d5abaf9d8ac" => :yosemite
    sha256 "df5160db16962c5bbf2a64d352b0fe5ff5e07213b44b5e01cc140bbfda297958" => :mavericks
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
    url "https://poppler.freedesktop.org/poppler-data-0.4.7.tar.gz"
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
