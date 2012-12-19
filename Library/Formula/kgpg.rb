require 'base_kde_formula'

class Kgpg < BaseKdeFormula
  homepage 'http://utils.kde.org/projects/kgpg/'
  url 'http://download.kde.org/stable/4.9.4/src/kgpg-4.9.4.tar.xz'
  sha1 '30b379e044c18dc28410bffb340bead19c2df3c7'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kgpg-4.9.95.tar.xz'
    sha1 'fe31000a177607f8f5ea826309bfdaccec3007a5'
  end

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
