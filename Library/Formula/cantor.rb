require 'base_kde_formula'

class Ucantor < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/cantor-4.8.1.tar.xz'
  sha1 'bc98d41262454de5aee65b124e7f93041ad639af'

  depends_on 'kdelibs'
end


