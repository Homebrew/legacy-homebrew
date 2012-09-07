require 'base_kde_formula'

class Calligra < BaseKdeFormula
  homepage 'http://www.calligra-suite.org/'
  url 'http://download.kde.org/stable/calligra-latest/calligra-2.4.2.tar.bz2'
  sha1 'd44a6b321b0b90122b86e074785546f4a2b0d066'
  depends_on 'kdelibs'
  # ENV.x11 # if your formula requires any X11 headers
  # ENV.j1  # if your formula's build system can't parallelize
end
