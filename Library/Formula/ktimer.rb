require 'base_kde_formula'

class Ktimer < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/ktimer-4.10.2.tar.xz'
  sha1 '2348d09267f173201b1ce426f0831e444602545d'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/ktimer-4.10.2.tar.xz'
    sha1 '2348d09267f173201b1ce426f0831e444602545d'
  end

  depends_on 'kdelibs'
end
