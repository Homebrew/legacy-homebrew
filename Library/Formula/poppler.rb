require 'formula'

class Poppler < Formula
  homepage 'http://poppler.freedesktop.org'
  url 'http://poppler.freedesktop.org/poppler-0.26.5.tar.xz'
  sha1 '12937666faee80bae397a8338a3357e864d77d53'

  bottle do
    sha1 "d9e4eb378fd6b1008b7b619f0f86a73f8779811d" => :mavericks
    sha1 "c2cc110ecf9fded23587ba2c527071badda4cb6c" => :mountain_lion
    sha1 "3d97e8dc2963e068bad40eeb846f176463b1b1ff" => :lion
  end

  option 'with-qt4', 'Build Qt backend'
  option 'with-lcms2', 'Use color management system'

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

  depends_on 'qt' if build.with? 'qt4'
  depends_on 'little-cms2' if build.with? 'lcms2'

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

    if build.with? "qt4"
      args << "--enable-poppler-qt4"
    else
      args << "--disable-poppler-qt4"
    end

    args << "--enable-cms=lcms2" if build.with? "lcms2"

    system "./configure", *args
    system "make install"
    resource('font-data').stage { system "make", "install", "prefix=#{prefix}" }
  end
end
