class Poppler < Formula
  homepage "http://poppler.freedesktop.org"
  url "http://poppler.freedesktop.org/poppler-0.32.0.tar.xz"
  sha256 "4963e31ba5e17530a87b16588e22928bc044e8d28d02303dded981bff6725b98"

  bottle do
    sha1 "b83e3b7fe032d69343367ceb481a0387e447e565" => :yosemite
    sha1 "c1693c4f5dddc088b6ea53640610918416d7e08c" => :mavericks
    sha1 "36ca1676e824fe8532ad6c6e826685c0e39ac808" => :mountain_lion
  end

  option "with-qt", "Build Qt backend"
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
  depends_on "little-cms2" => :optional

  conflicts_with "pdftohtml", :because => "both install `pdftohtml` binaries"

  resource "font-data" do
    url "http://poppler.freedesktop.org/poppler-data-0.4.7.tar.gz"
    sha256 "e752b0d88a7aba54574152143e7bf76436a7ef51977c55d6bd9a48dccde3a7de"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-xpdf-headers
      --enable-poppler-glib
      --disable-gtk-test
      --enable-introspection=yes
    ]

    if build.with? "qt"
      args << "--enable-poppler-qt4"
    else
      args << "--disable-poppler-qt4"
    end

    args << "--enable-cms=lcms2" if build.with? "little-cms2"

    system "./configure", *args
    system "make", "install"
    resource("font-data").stage { system "make", "install", "prefix=#{prefix}" }
  end

  test do
    system bin/"pdfinfo", HOMEBREW_PREFIX/"Library/Homebrew/test/fixtures/test.pdf"
  end
end
