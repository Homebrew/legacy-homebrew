require 'formula'

def glib?; ARGV.include? '--with-glib'; end
def qt?; ARGV.include? '--with-qt4'; end

class PopplerData < Formula
  url 'http://poppler.freedesktop.org/poppler-data-0.4.5.tar.gz'
  md5 '448dd7c5077570e340340706cef931aa'
end

class Poppler < Formula
  url 'http://poppler.freedesktop.org/poppler-0.18.3.tar.gz'
  homepage 'http://poppler.freedesktop.org'
  md5 'd70d2d63d8acd29c97185f7e5f09c9b4'

  depends_on 'pkg-config' => :build
  depends_on 'qt' if qt?
  depends_on 'glib' if glib?
  depends_on 'cairo' if glib? # Needs a newer Cairo build than OS X 10.6.7 provides

  def options
    [
      ["--with-qt4", "Build Qt backend"],
      ["--with-glib", "Build Glib backend"]
    ]
  end

  def install
    ENV.x11 # For Fontconfig headers

    if qt?
      ENV['POPPLER_QT4_CFLAGS'] = `#{HOMEBREW_PREFIX}/bin/pkg-config QtCore QtGui --libs`.chomp
      ENV.append 'LDFLAGS', "-Wl,-F#{HOMEBREW_PREFIX}/lib"
    end

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--enable-xpdf-headers"]
    # Explicitly disable Qt if not requested because `POPPLER_QT4_CFLAGS` won't
    # be set and the build will fail.
    args << ( qt? ? '--enable-poppler-qt4' : '--disable-poppler-qt4' )
    args << '--enable-poppler-glib' if glib?

    system "./configure", *args
    system "make install"

    # Install poppler font data.
    PopplerData.new.brew do
      system "make install prefix=#{prefix}"
    end
  end
end
