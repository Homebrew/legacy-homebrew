require 'base_kde_formula'

class Kamera < BaseKdeFormula
  homepage 'http://www.thekompany.com/projects/gphoto/'
  url 'http://download.kde.org/stable/4.10.2/src/kamera-4.10.2.tar.xz'
  sha1 '5ee6904705c1d323c7c0d780d0ecf65f93175981'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kamera-4.10.2.tar.xz'
    sha1 '5ee6904705c1d323c7c0d780d0ecf65f93175981'
  end

  depends_on 'gphoto2'
  depends_on 'qt'
end
