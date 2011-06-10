require 'formula'

class PopplerData < Formula
  url 'http://poppler.freedesktop.org/poppler-data-0.4.4.tar.gz'
  md5 'f3a1afa9218386b50ffd262c00b35b31'
end

class Poppler < Formula
  url 'http://poppler.freedesktop.org/poppler-0.16.6.tar.gz'
  homepage 'http://poppler.freedesktop.org/'
  md5 '592a564fb7075a845f75321ed6425424'

  depends_on 'pkg-config' => :build
  depends_on "qt" if ARGV.include? "--with-qt4"

  def options
    [
      ["--with-qt4", "Include Qt4 support (which compiles all of Qt4!)"],
      ["--enable-xpdf-headers", "Also install XPDF headers."]
    ]
  end

  def install
    ENV.x11 # For Fontconfig headers

    if ARGV.include? "--with-qt4"
      ENV['POPPLER_QT4_CFLAGS'] = `pkg-config QtCore QtGui --libs`.chomp.strip
      ENV.append 'LDFLAGS', "-Wl,-F#{HOMEBREW_PREFIX}/lib"
    end

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--disable-poppler-qt4" unless ARGV.include? "--with-qt4"
    args << "--enable-xpdf-headers" if ARGV.include? "--enable-xpdf-headers"

    system "./configure", *args
    system "make install"

    # Install poppler font data.
    PopplerData.new.brew do
      system "make install prefix=#{prefix}"
    end
  end
end
