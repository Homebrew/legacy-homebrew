require 'base_kde_formula'

class Calligra < BaseKdeFormula
  homepage 'http://www.calligra-suite.org/'
  url 'http://download.kde.org/stable/calligra-latest/calligra-2.5.4.tar.bz2'
  md5 '54f4677a9b00eec5951fa2386ba271a1'
  depends_on 'kdelibs'
  # ENV.x11 # if your formula requires any X11 headers
  # ENV.j1  # if your formula's build system can't parallelize
end
