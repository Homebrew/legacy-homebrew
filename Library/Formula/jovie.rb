require 'base_kde_formula'

class Ujovie < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/jovie-4.8.1.tar.xz'
  sha1 '4ac647ac3823b6a4f01f839f3e11bca09d6353ee'

  depends_on 'kdelibs'
end


