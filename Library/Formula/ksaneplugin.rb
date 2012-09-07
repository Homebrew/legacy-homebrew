require 'base_kde_formula'

class Uksaneplugin < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/ksaneplugin-4.8.1.tar.xz'
  sha1 '6f59ab3630850d9ceee15e9d01cb1b6b6dedc9e9'

  depends_on 'kdelibs'
end


