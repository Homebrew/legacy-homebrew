require 'base_kde_formula'

class KdeWallpapers < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-wallpapers-4.10.2.tar.xz'
  sha1 '5919c022631560f32fb660d2ac6cb4ea2017389a'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-wallpapers-4.10.2.tar.xz'
    sha1 '5919c022631560f32fb660d2ac6cb4ea2017389a'
  end

  depends_on 'kdelibs'
end
