require 'base_kde_formula'

class Kig < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kig-4.10.2.tar.xz'
  sha1 '0066e645cd11d239678aa90ede938daf4dd0942d'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kig-4.10.2.tar.xz'
    sha1 '0066e645cd11d239678aa90ede938daf4dd0942d'
  end

  depends_on 'kdelibs'
end
