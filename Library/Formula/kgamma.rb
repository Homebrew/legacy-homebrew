require 'base_kde_formula'

class Kgamma < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kgamma-4.10.2.tar.xz'
  sha1 '4f6e5269500800da897643246363b9c18ce36843'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kgamma-4.10.2.tar.xz'
    sha1 '4f6e5269500800da897643246363b9c18ce36843'
  end

  depends_on 'kdelibs'
end
