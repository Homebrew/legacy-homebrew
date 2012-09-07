require 'base_kde_formula'

class Ukmag < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kmag-4.8.1.tar.xz'
  sha1 '35686d11ecf5e2783b7518499300a715ef27108d'

  depends_on 'kdelibs'
end


