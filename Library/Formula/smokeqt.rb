require 'base_kde_formula'

class Usmokeqt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/smokeqt-4.8.1.tar.xz'
  sha1 '7af6089df0ffefe7a88600e43641dfd18da8e3e8'

  depends_on 'kdelibs'
end


