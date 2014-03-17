require 'formula'

class Ttf2pt1 < Formula
  homepage 'http://ttf2pt1.sourceforge.net/'
  url 'https://downloads.sourceforge.net/ttf2pt1/ttf2pt1-3.4.4.tgz'
  sha1 '936771b11a740c16a8e0adb737b54b22cca18cb2'

  # From MacPorts, needed to find free-type on OS X.
  patch :p0 do
    url "https://trac.macports.org/export/75341/trunk/dports/print/ttf2pt1/files/patch-ft.c"
    sha1 "860db2a018cf9cc66f7c7d83263fffb2d5da07a3"
  end

  def install
    system "make", "all", "INSTDIR=#{prefix}"
    bin.install 'ttf2pt1'
    man1.install 'ttf2pt1.1'
  end
end
