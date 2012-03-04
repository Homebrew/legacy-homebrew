require 'base_kde_formula'

class Akonadi < BaseKdeFormula
  url 'http://mirrors.isc.org/pub/kde/stable/akonadi/src/akonadi-1.7.0.tar.bz2'
  homepage 'http://pim.kde.org/akonadi/'
  md5 '804309dca70ede35b4a654ab764e9079'

  depends_on 'shared-mime-info'
  depends_on 'mysql'
  depends_on 'soprano'
  depends_on 'boost'
  depends_on 'qt'
end
