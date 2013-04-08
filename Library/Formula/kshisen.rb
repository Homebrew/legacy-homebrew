require 'base_kde_formula'

class Kshisen < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kshisen-4.10.2.tar.xz'
  sha1 'df41aac7d3048ccfdbd55b62872643c7325b9722'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kshisen-4.10.2.tar.xz'
    sha1 'df41aac7d3048ccfdbd55b62872643c7325b9722'
  end

  depends_on 'kdelibs'
end
