require 'base_kde_formula'

class Kruler < BaseKdeFormula
  homepage 'http://kde.org'
  url 'http://download.kde.org/stable/4.8.1/src/kruler-4.8.1.tar.xz'
  sha1 'e551744f2e3f772450eb6fe21358067e9448799e'
  depends_on 'kdelibs'
end
