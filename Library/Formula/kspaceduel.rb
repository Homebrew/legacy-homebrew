require 'base_kde_formula'

class Kspaceduel < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kspaceduel-4.10.2.tar.xz'
  sha1 '2f1cbca7dea4e70d923bef72a2c57ad733712998'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kspaceduel-4.10.2.tar.xz'
    sha1 '2f1cbca7dea4e70d923bef72a2c57ad733712998'
  end

  depends_on 'kdelibs'
end
