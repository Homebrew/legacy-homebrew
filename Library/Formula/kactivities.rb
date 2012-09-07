require 'base_kde_formula'

class Ukactivities < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kactivities-4.8.1.tar.xz'
  sha1 '29979514848633da71780b342e7328063bd47d07'

  depends_on 'kdelibs'
end


