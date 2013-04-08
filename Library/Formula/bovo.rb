require 'base_kde_formula'

class Bovo < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/bovo-4.10.2.tar.xz'
  sha1 '9af42dbd99c552adcba59deeaa6407b2465bde87'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/bovo-4.10.2.tar.xz'
    sha1 '9af42dbd99c552adcba59deeaa6407b2465bde87'
  end

  depends_on 'kdelibs'
end
