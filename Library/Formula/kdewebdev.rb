require 'base_kde_formula'

class Ukdewebdev < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdewebdev-4.8.1.tar.xz'
  sha1 'c707886d79d9ba150c408326efccf24847d5dc38'

  depends_on 'kdelibs'
end


