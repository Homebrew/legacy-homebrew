require 'formula'

class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage 'http://poppler.freedesktop.org'
  url 'http://poppler.freedesktop.org/poppler-0.29.0.tar.xz'
  sha1 'ba3330ab884e6a139ca63dd84d0c1c676f545b5e'

  bottle do
    sha1 "b83e3b7fe032d69343367ceb481a0387e447e565" => :yosemite
    sha1 "c1693c4f5dddc088b6ea53640610918416d7e08c" => :mavericks
    sha1 "36ca1676e824fe8532ad6c6e826685c0e39ac808" => :mountain_lion
  end

  option "with-qt", "Build Qt backend"
  option "with-qt5", "Build Qt5 backend"
  option "with-little-cms2", "Use color management system"

  deprecated_option "with-qt4" => "with-qt"
  deprecated_option "with-lcms2" => "with-little-cms2"

  depends_on 'pkg-config' => :build
  depends_on 'cairo'
  depends_on 'fontconfig'
  depends_on 'freetype'
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gobject-introspection'
  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'libtiff'
  depends_on 'openjpeg'

  depends_on "qt" => :optional
  depends_on "qt5" => :optional
  depends_on "little-cms2" => :optional

  conflicts_with 'pdftohtml', :because => 'both install `pdftohtml` binaries'

  resource 'font-data' do
    url 'http://poppler.freedesktop.org/poppler-data-0.4.7.tar.gz'
    sha1 '556a5bebd0eb743e0d91819ba11fd79947d8c674'
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
    elsif build.with? "qt5"
      args << "--enable-poppler-qt5"
    else
      args << "--disable-poppler-qt4" << "--disable-poppler-qt5"
    end

    args << "--enable-cms=lcms2" if build.with? "little-cms2"

    system "./configure", *args
    system "make install"
    resource('font-data').stage { system "make", "install", "prefix=#{prefix}" }
  end
end
