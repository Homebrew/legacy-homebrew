require 'formula'

def glib?; ARGV.include? '--with-glib'; end
def qt?; ARGV.include? '--with-qt4'; end

class PopplerData < Formula
  url 'http://cgit.freedesktop.org/poppler/poppler-data/snapshot/poppler-data-POPPLER_DATA_0_4_5.tar.gz'
  md5 '448dd7c5077570e340340706cef931aa'
  head 'http://anongit.freedesktop.org/git/poppler/poppler-data.git'
  version '0.4.5'
end

class Poppler < Formula
  homepage 'http://poppler.freedesktop.org'
  url 'http://cgit.freedesktop.org/poppler/poppler/snapshot/poppler-poppler-0.20.2.tar.gz'
  md5 'c17fab1ef78bae7a44083fb0a15ca374'
  head 'http://anongit.freedesktop.org/git/poppler/poppler.git'
  version '0.20.2'

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
