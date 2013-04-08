require 'base_kde_formula'

class Lskat < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/lskat-4.10.2.tar.xz'
  sha1 'a3f3450e446b365d7171552ddd00ab84f589b943'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/lskat-4.10.2.tar.xz'
    sha1 'a3f3450e446b365d7171552ddd00ab84f589b943'
  end

  depends_on 'kdelibs'
end
