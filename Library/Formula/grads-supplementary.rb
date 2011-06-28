require 'formula'

class GradsSupplementary < Formula
  url 'ftp://grads.iges.org/grads/data2.tar.gz'
  homepage 'http://www.iges.org/grads/grads.html'
  md5 'cacf16d75f53c876ff18bd4f8100fa66'
  version '2.0a9'

  def install
    mkdir 'grads'
    mv 'tables', 'grads/'
    mv 'font0.dat', 'grads/'
    mv 'font1.dat', 'grads/'
    mv 'font2.dat', 'grads/'
    mv 'font3.dat', 'grads/'
    mv 'font4.dat', 'grads/'
    mv 'font5.dat', 'grads/'
    mv 'hires', 'grads/'
    mv 'lowres', 'grads/'
    mv 'mres', 'grads/'
    mv 'udunits.dat', 'grads/'
    lib.install Dir['grads']
  end
end
