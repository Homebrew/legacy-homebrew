require 'base_kde_formula'

class Kdepimlibs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.0/src/kdepimlibs-4.8.0.tar.bz2'
  md5 '3e1ea1d5f56eb87c0c305d941ac414c0'

  depends_on 'gpgme'
  depends_on 'akonadi'
  depends_on 'libical'
  depends_on 'kdelibs'
  depends_on 'nepomuk' # part of kdelibs ?
end
