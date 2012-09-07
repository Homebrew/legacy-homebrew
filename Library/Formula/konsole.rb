require 'base_kde_formula'

class Konsole < BaseKdeFormula
  homepage 'http://konsole.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/konsole-4.8.1.tar.xz'
  sha1 '23490d929c6c3a56485e4c6585a1d10af9810651'

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
