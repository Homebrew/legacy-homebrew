require 'base_kde_formula'

class Kgeography < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kgeography-4.10.2.tar.xz'
  sha1 '14cd9d3d788a9f0068af3e10f26f0375b5c7251a'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kgeography-4.10.2.tar.xz'
    sha1 '14cd9d3d788a9f0068af3e10f26f0375b5c7251a'
  end

  depends_on 'kdelibs'
end
