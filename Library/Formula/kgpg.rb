require 'base_kde_formula'

class Kgpg < BaseKdeFormula
  homepage 'http://utils.kde.org/projects/kgpg/'
  url 'http://download.kde.org/stable/4.10.2/src/kgpg-4.10.2.tar.xz'
  sha1 'fbe8df63cbfbff616493267253b03e153e2bbc40'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kgpg-4.10.2.tar.xz'
    sha1 'fbe8df63cbfbff616493267253b03e153e2bbc40'
  end

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
