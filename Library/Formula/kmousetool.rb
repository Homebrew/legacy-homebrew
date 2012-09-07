require 'base_kde_formula'

class Ukmousetool < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kmousetool-4.8.1.tar.xz'
  sha1 '8b3f0323602ab33a5749c7e5c75d50b62c352786'

  depends_on 'kdelibs'
end


