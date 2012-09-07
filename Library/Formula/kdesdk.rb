require 'base_kde_formula'

class Ukdesdk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdesdk-4.8.1.tar.xz'
  sha1 '5104445024047ae01099e7baa8e5b47a63b76198'

  depends_on 'kdelibs'
end


