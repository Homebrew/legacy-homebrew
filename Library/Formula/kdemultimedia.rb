require 'base_kde_formula'

class Ukdemultimedia < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdemultimedia-4.8.1.tar.xz'
  sha1 '9de14f08c7f1649201be029b8e683a296cc75f52'

  depends_on 'kdelibs'
end


