require 'base_kde_formula'

class Ffmpegthumbs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/ffmpegthumbs-4.10.2.tar.xz'
  sha1 'acd089018480ae879d241968a3be1627fb2b3298'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/ffmpegthumbs-4.10.2.tar.xz'
    sha1 'acd089018480ae879d241968a3be1627fb2b3298'
  end

  depends_on 'kdelibs'
end
