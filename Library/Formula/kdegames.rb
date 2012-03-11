require 'base_kde_formula'

class Ukdegames < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdegames-4.8.1.tar.xz'
  sha1 'bcf764fd1f2f8083c388c17f26b83eeac568b1d5'

  depends_on 'kdelibs'
end


