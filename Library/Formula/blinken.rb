require 'base_kde_formula'

class Blinken < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/blinken-4.9.4.tar.xz'
  sha1 'e8a2ed440d62edaf302de898f84ba6b3af0eb21e'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/blinken-4.9.95.tar.xz'
    sha1 '975d7220a99ef8cbc4129361ece150b53519335c'
  end

  depends_on 'kdelibs'
end
