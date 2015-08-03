class Latex2rtf < Formula
  desc "Translate LaTeX to RTF"
  homepage "http://latex2rtf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.8/latex2rtf-2.3.8.tar.gz"
  sha256 "5484530de16e96ce76aedf969c464656a5f8834e748849d9009049e26f8c4143"

  def install
    inreplace "Makefile", "cp -p doc/latex2rtf.html $(DESTDIR)$(SUPPORTDIR)", "cp -p doc/web/* $(DESTDIR)$(SUPPORTDIR)"
    system "make", "DESTDIR=",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "INFODIR=#{info}",
                   "SUPPORTDIR=#{share}/latex2rtf",
                   "CFGDIR=#{share}/latex2rtf/cfg",
                   "install"
  end
end
