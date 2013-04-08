require 'base_kde_formula'

class Ksquares < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/ksquares-4.10.2.tar.xz'
  sha1 '76651a698b03488cec1af125fb27bcf2d509c30a'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/ksquares-4.10.2.tar.xz'
    sha1 '76651a698b03488cec1af125fb27bcf2d509c30a'
  end

  depends_on 'kdelibs'
end
