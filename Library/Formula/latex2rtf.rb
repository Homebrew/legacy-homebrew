require "formula"

class Latex2rtf < Formula
  homepage "http://latex2rtf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.8/latex2rtf-2.3.8.tar.gz"
  sha1 "334de546342078c7a3213cb5b554a0a900952641"

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
