require 'base_kde_formula'

class Ukgamma < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kgamma-4.8.1.tar.xz'
  sha1 '9829ed03f9faac64afafe83bb84eae0048929dfe'

  depends_on 'kdelibs'
end


