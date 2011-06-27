require 'formula'

def glib?; ARGV.include? "--with-glib"; end

class PopplerData < Formula
  url 'http://poppler.freedesktop.org/poppler-data-0.4.4.tar.gz'
  md5 'f3a1afa9218386b50ffd262c00b35b31'
end

class Poppler < Formula
  url 'http://poppler.freedesktop.org/poppler-0.16.6.tar.gz'
  homepage 'http://poppler.freedesktop.org/'
  md5 '592a564fb7075a845f75321ed6425424'

  depends_on 'pkg-config' => :build
  depends_on 'qt' if ARGV.include? "--with-qt4"
  depends_on 'glib' if glib?
  depends_on 'cairo' if glib? # Needs a newer Cairo build than OS X 10.6.7 provides

  def options
    [
      ["--with-qt4", "Build Qt backend"],
      ["--with-glib", "Build Glib backend"],
      ["--enable-xpdf-headers", "Also install XPDF headers"]
    ]
  end

  def install
    ENV.x11 # For Fontconfig headers

    if ARGV.include? "--with-qt4"
      ENV['POPPLER_QT4_CFLAGS'] = `#{HOMEBREW_PREFIX}/bin/pkg-config QtCore QtGui --libs`.chomp.strip
      ENV.append 'LDFLAGS', "-Wl,-F#{HOMEBREW_PREFIX}/lib"
    end

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-poppler-qt4" if ARGV.include? "--with-qt4"
    args << "--enable-poppler-glib" if glib?
    args << "--enable-xpdf-headers" if ARGV.include? "--enable-xpdf-headers"

    system "./configure", *args
    system "make install"

    # Install poppler font data.
    PopplerData.new.brew do
      system "make install prefix=#{prefix}"
    end
  end
end
