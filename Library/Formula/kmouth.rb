require 'base_kde_formula'

class Ukmouth < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kmouth-4.8.1.tar.xz'
  sha1 'b4cecf89eea96892608fd125635ea9f9f7fee8be'

  depends_on 'kdelibs'
end


