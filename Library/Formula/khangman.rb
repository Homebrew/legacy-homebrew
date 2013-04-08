require 'base_kde_formula'

class Khangman < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/khangman-4.10.2.tar.xz'
  sha1 '2795c1ada9898854fe3a8ffd8a92c8ad5cd3eb04'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/khangman-4.10.2.tar.xz'
    sha1 '2795c1ada9898854fe3a8ffd8a92c8ad5cd3eb04'
  end

  depends_on 'kdelibs'
end
