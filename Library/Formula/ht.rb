require 'formula'

class Ht < Formula
  url 'http://downloads.sourceforge.net/project/hte/ht-source/ht-2.0.20.tar.bz2'
  homepage 'http://hte.sf.net/'
  sha256 '4aa162f10a13e60859bef1f04c6529f967fdfd660ae421ee25eab1fbabcd1ed0'

  depends_on 'lzo'

  def install
    system "chmod +x ./install-sh"
    system "echo \"%s/\\\\(CURSES_LIB=ncurses\\\\)w/\\\\1/\\nwq\" | " +
           "ed -s configure"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
