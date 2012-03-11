require 'base_kde_formula'

class Ukdenetwork < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdenetwork-4.8.1.tar.xz'
  sha1 'e914a1d990ff42ec88cf37ffc897ae9df9b1fa45'

  depends_on 'kdelibs'
end


