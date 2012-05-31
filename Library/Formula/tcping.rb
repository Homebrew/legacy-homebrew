require 'formula'

class Tcping < Formula
  url 'http://www.linuxco.de/tcping/tcping-1.3.5.tar.gz'
  homepage 'http://www.linuxco.de/tcping/tcping.html'
  md5 'f9dd03c730db6999ca8beca479f078e3'

  def install
    system "make"
    bin.install 'tcping'
  end
end
