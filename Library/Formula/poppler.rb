require 'formula'

class Poppler < Formula
  homepage 'http://poppler.freedesktop.org'
  url 'http://poppler.freedesktop.org/poppler-0.26.2.tar.xz'
  sha1 'd4a3a5c2f97217a5de250d53ef810f26ab581673'

  bottle do
    sha1 "ddf1dc522eab6f213186436464e1008ddf53db45" => :mavericks
    sha1 "a2b9fcb92cab46e5910869283b0e8fcb10734e7f" => :mountain_lion
    sha1 "521710681ffad0770dcc2394088cd38ea513cd82" => :lion
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
    url 'http://poppler.freedesktop.org/poppler-data-0.4.6.tar.gz'
    sha1 'f030563eed9f93912b1a546e6d87936d07d7f27d'
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
