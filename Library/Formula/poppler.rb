require 'formula'

class Poppler < Formula
  homepage 'http://poppler.freedesktop.org'
  url 'http://poppler.freedesktop.org/poppler-0.29.0.tar.xz'
  sha1 'ba3330ab884e6a139ca63dd84d0c1c676f545b5e'

  bottle do
    sha1 "acd2993598f19bbc43a97290ddad7e7a9ea057a7" => :yosemite
    sha1 "51909b61a845b2a3a37b6a6605ce6e90a66f3c57" => :mavericks
    sha1 "bbcebe2b5ac7d895ec6a3839f2fffbffd62c478e" => :mountain_lion
  end

  option "with-qt", "Build Qt backend"
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
  depends_on "little-cms2" => :optional

  conflicts_with 'pdftohtml', :because => 'both install `pdftohtml` binaries'

  conflicts_with 'pdf2image', 'xpdf',
    :because => 'poppler, pdf2image, and xpdf install conflicting executables'

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
    else
      args << "--disable-poppler-qt4"
    end

    args << "--enable-cms=lcms2" if build.with? "little-cms2"

    system "./configure", *args
    system "make install"
    resource('font-data').stage { system "make", "install", "prefix=#{prefix}" }
  end
end
