require 'base_kde_formula'

class Libechonest < BaseKdeFormula
  url 'http://pwsp.cleinias.com/libechonest-1.1.8.tar.bz2'
  homepage 'https://projects.kde.org/projects/playground/libs/libechonest'
  sha1 'ce79da389979e7deca2858b1d677312f027b6264'
  depends_on 'qt'
  depends_on 'qjson'
end
