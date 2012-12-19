require 'base_kde_formula'

class Kamera < BaseKdeFormula
  homepage 'http://www.thekompany.com/projects/gphoto/'
  depends_on 'gphoto2'
  depends_on 'qt'
  url 'http://download.kde.org/stable/4.9.4/src/kamera-4.9.4.tar.xz'
  sha1 '6a2c0ff74e1a11d0f00c6749b3726b233d283040'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kamera-4.9.95.tar.xz'
    sha1 '738977a1205cd8eb24f9fa30fca503b40911c92c'
  end

end
