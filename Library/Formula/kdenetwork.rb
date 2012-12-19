require 'base_kde_formula'

class Kdenetwork < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdenetwork-4.9.4.tar.xz'
  sha1 '1541bfd584fc86e29782dbfdbb94c2b183a2bd48'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdenetwork-4.9.95.tar.xz'
    sha1 '1568c53a949acf7c110f76e153a78ed28114bc4d'
  end

  depends_on 'kdelibs'
end
