require 'base_kde_formula'

class Kamera < BaseKdeFormula
  homepage 'http://www.thekompany.com/projects/gphoto/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kamera-4.8.1.tar.xz'
  sha1 '98a54976430aa3061d14f5b71c6d5d896abc9baf'
  depends_on 'gphoto2'
  depends_on 'qt'
end
