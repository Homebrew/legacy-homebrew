require 'formula'

class Latex2rtf < Formula
  homepage 'http://latex2rtf.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.5/latex2rtf-2.3.5.tar.gz'
  sha1 '12d5d33b8b3c841a401bcdaf50752259cd3aa5d5'

  def install
    inreplace 'Makefile', "cp -p doc/latex2rtf.html $(DESTDIR)$(SUPPORTDIR)", "cp -p doc/web/* $(DESTDIR)$(SUPPORTDIR)"
    system "make", "DESTDIR=",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "INFODIR=#{info}",
                   "SUPPORTDIR=#{share}/latex2rtf",
                   "CFGDIR=#{share}/latex2rtf/cfg",
                   "install"
  end
end
