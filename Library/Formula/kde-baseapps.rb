require 'base_kde_formula'

class KdeBaseapps < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-baseapps-4.9.4.tar.xz'
  sha1 'b68e76766331272a45b1d897adf4c1928a11e747'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-baseapps-4.9.95.tar.xz'
    sha1 'a28eebf05bc484a2b91c33c8c700a0f09c57ed3d'
  end

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
