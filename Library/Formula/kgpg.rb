require 'base_kde_formula'

class Kgpg < BaseKdeFormula
  homepage 'http://utils.kde.org/projects/kgpg/'
  url 'http://download.kde.org/stable/4.8.1/src/kgpg-4.8.1.tar.xz'
  sha1 '8ba8fcf6f6f8a8ed0788c3d03a3f42652d925477'

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
