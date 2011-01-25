require 'formula'

class TerminusFont <Formula
  url 'http://sourceforge.net/projects/terminus-font/files/terminus-font-4.32/terminus-font-4.32.tar.gz'
  homepage 'http://terminus-font.sourceforge.net/'
  md5 '9b74047edcc236a7d4af8abf966c3e7c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
						  "--x11dir=#{share}/fonts"
    system "make"
    system "make install fontdir"
    system "mkfontdir #{share}/fonts"
  end
end
