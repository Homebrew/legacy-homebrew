require 'base_kde_formula'

class Kdepim < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdepim-4.8.1.tar.xz'
  sha1 '93222d56f9adde015cb202a1ad3b194ac52e6bda'

  depends_on 'kdepimlibs'
end

