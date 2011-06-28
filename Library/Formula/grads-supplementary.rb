require 'formula'

class GradsSupplementary < Formula
  url 'ftp://grads.iges.org/grads/data2.tar.gz'
  homepage 'http://www.iges.org/grads/grads.html'
  md5 'cacf16d75f53c876ff18bd4f8100fa66'
  version '2.0a9'

  def install
    mkdir 'grads'
    mv ['tables', 'font0.dat', 'font1.dat', 'font2.dat', 'font3.dat', 'font4.dat', 'font5.dat', 'hires', 'lowres', 'mres', 'udunits.dat'], 'grads/'
    lib.install Dir['grads']
  end
end
