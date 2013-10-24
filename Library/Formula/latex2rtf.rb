require 'formula'

class Latex2rtf < Formula
  homepage 'http://latex2rtf.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.3/latex2rtf-2.3.3.tar.gz'
  sha1 '85dd36e8595f92f41b0b173a6b42279333bbb1a9'

  def install
    system "make", "DESTDIR=",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "INFODIR=#{info}",
                   "SUPPORTDIR=#{share}/latex2rtf",
                   "CFGDIR=#{share}/latex2rtf/cfg",
                   "install"
  end
end
