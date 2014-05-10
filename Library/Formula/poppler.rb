require 'formula'

class Poppler < Formula
  homepage 'http://poppler.freedesktop.org'
  url 'http://poppler.freedesktop.org/poppler-0.26.0.tar.xz'
  sha1 '1f5d08ee01683c309688f17116d18bf47b13f001'

  option 'with-qt4', 'Build Qt backend'
  option 'with-glib', 'Build Glib backend' # requires cairo
  option 'with-lcms2', 'Use color management system'

  depends_on 'pkg-config' => :build

  depends_on 'libpng'
  depends_on 'fontconfig'
  depends_on 'openjpeg'

  depends_on 'qt' if build.with? 'qt4'
  depends_on 'glib' => :optional
  depends_on 'little-cms2' if build.with? 'lcms2'
  depends_on 'cairo' if build.with? 'glib'

  conflicts_with 'pdftohtml', :because => 'both install `pdftohtml` binaries'

  conflicts_with 'pdf2image', 'xpdf',
    :because => 'poppler, pdf2image, and xpdf install conflicting executables'

  resource 'font-data' do
    url 'http://poppler.freedesktop.org/poppler-data-0.4.6.tar.gz'
    sha1 'f030563eed9f93912b1a546e6d87936d07d7f27d'
  end

  def install
    if build.with? 'qt4'
      ENV['POPPLER_QT4_CFLAGS'] = `#{HOMEBREW_PREFIX}/bin/pkg-config QtCore QtGui --libs`.chomp
      ENV.append 'LDFLAGS', "-Wl,-F#{HOMEBREW_PREFIX}/lib"
    end

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--enable-xpdf-headers"]
    # Explicitly disable Qt if not requested because `POPPLER_QT4_CFLAGS` won't
    # be set and the build will fail.
    #
    # Also, explicitly disable Glib as Poppler will find it and set up to
    # build, but Superenv will have stripped the Glib utilities out of the
    # PATH.
    args << ( build.with?('qt4') ? '--enable-poppler-qt4' : '--disable-poppler-qt4' )
    args << ( build.with?('glib') ? '--enable-poppler-glib' : '--disable-poppler-glib' )
    args << ( build.with?('glib') ? '' : '--disable-cairo-output' )
    args << ( build.with?('lcms2') ? '--enable-cms=lcms2' : '' )

    system "./configure", *args
    system "make install"
    resource('font-data').stage { system "make", "install", "prefix=#{prefix}" }
  end
end
