require 'formula'

class PopplerData < Formula
  url 'http://poppler.freedesktop.org/poppler-data-0.4.6.tar.gz'
  sha1 'f030563eed9f93912b1a546e6d87936d07d7f27d'
end

class Poppler < Formula
  homepage 'http://poppler.freedesktop.org'
  url 'http://poppler.freedesktop.org/poppler-0.22.0.tar.gz'
  sha1 'd9cfc390a5aa2aaf976318d9bf3642336f625981'

  option 'with-qt4', 'Build Qt backend'
  option 'with-glib', 'Build Glib backend'

  depends_on 'pkg-config' => :build

  depends_on :fontconfig
  depends_on 'openjpeg'

  depends_on 'qt' if build.include? 'with-qt4'
  depends_on 'glib' if build.include? 'with-glib'
  depends_on 'cairo' if build.include? 'with-glib' # Needs a newer Cairo build than OS X 10.6.7 provides

  def install
    if build.include? 'with-qt4'
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
    args << ( build.include?('with-qt4') ? '--enable-poppler-qt4' : '--disable-poppler-qt4' )
    args << ( build.include?('with-glib') ? '--enable-poppler-glib' : '--disable-poppler-glib' )

    system "./configure", *args
    system "make install"

    # Install poppler font data.
    PopplerData.new.brew do
      system "make", "install", "prefix=#{prefix}"
    end
  end
end
