require 'base_kde_formula'

class Kmix < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kmix-4.10.2.tar.xz'
  sha1 '26617eeac172e3375cd097c8350ebdb32412e9fa'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kmix-4.10.2.tar.xz'
    sha1 '26617eeac172e3375cd097c8350ebdb32412e9fa'
  end

  depends_on 'kdelibs'
end
