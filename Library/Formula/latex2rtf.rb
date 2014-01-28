require 'formula'

class Latex2rtf < Formula
  homepage 'http://latex2rtf.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.4/latex2rtf-2.3.4.tar.gz'
  sha1 '44cf5c7d037b01bff40fd419377826121267b6dd'

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
