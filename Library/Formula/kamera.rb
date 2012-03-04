require 'base_kde_formula'

class Kamera < BaseKdeFormula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.0/src/kamera-4.8.0.tar.bz2'
  homepage 'http://www.thekompany.com/projects/gphoto/'
  md5 '2d7340b1215c24d1e98875c5eea4d54d'
  depends_on 'gphoto2'
  depends_on 'qt' # with --qt3-support
end
