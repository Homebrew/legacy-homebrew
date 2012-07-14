require 'formula'

def glib?; ARGV.include? '--with-glib'; end
def qt?; ARGV.include? '--with-qt4'; end

class PopplerData < Formula
  url 'http://poppler.freedesktop.org/poppler-data-0.4.5.tar.gz'
  sha256 '3190bc457bafe4b158f79a08e8a3f1824031ec12acefc359e68e0f04da0f70fd'
end

class Poppler < Formula
  homepage 'http://poppler.freedesktop.org'
  url 'http://poppler.freedesktop.org/poppler-0.20.2.tar.gz'
  sha256 '2debc5034e0e85402957d84fb2674737658a3dbe8a3c631e1792e3f8c88ce369'

  depends_on 'pkg-config' => :build
  depends_on 'qt' if qt?
  depends_on 'glib' if glib?
  depends_on 'cairo' if glib? # Needs a newer Cairo build than OS X 10.6.7 provides
  depends_on :x11 # Fontconfig headers

  def options
    [
      ["--with-qt4", "Build Qt backend"],
      ["--with-glib", "Build Glib backend"]
    ]
  end

  def install
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
      system "make", "install", "prefix=#{prefix}"
    end
  end
end
