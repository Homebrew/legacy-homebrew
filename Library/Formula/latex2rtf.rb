require 'formula'

class Latex2rtf < Formula
  homepage 'http://latex2rtf.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.6/latex2rtf-2.3.6.tar.gz'
  sha1 'd0436c52ec4d82f379cdbd7c8b00ddac4f015da5'

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
