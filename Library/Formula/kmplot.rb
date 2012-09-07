require 'base_kde_formula'

class Ukmplot < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kmplot-4.8.1.tar.xz'
  sha1 '04eadb4a030e594c9ea09b55142640345b1c36c4'

  depends_on 'kdelibs'
end


