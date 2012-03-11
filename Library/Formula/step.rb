require 'base_kde_formula'

class Ustep < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/step-4.8.1.tar.xz'
  sha1 '5b8da2e1efe783e46042603d9ba87f1f464ba105'

  depends_on 'kdelibs'
end


