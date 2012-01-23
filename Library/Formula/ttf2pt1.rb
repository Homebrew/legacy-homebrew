require 'formula'

class Ttf2pt1 < Formula
  url 'http://downloads.sourceforge.net/ttf2pt1/ttf2pt1-3.4.4.tgz'
  homepage 'http://ttf2pt1.sourceforge.net/'
  md5 'cb143c07cc83167875ca09ea720d4932'

  def patches
    # From MacPorts, needed to find free-type on OS X.
    { 'p0' =>
      "https://trac.macports.org/export/75341/trunk/dports/print/ttf2pt1/files/patch-ft.c"
    }
  end

  def install
    inreplace 'Makefile', /^INSTDIR.*$/, "INSTDIR=#{prefix}"
    system "make all"
    bin.install 'ttf2pt1'
    man1.install 'ttf2pt1.1'
  end
end
