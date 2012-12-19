require 'base_kde_formula'

class Perlkde < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/perlkde-4.9.4.tar.xz'
  sha1 '8b43723d404d84fa87f6899ba3d332e3c035b583'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/perlkde-4.9.95.tar.xz'
    sha1 '302c590c9388a178fa68fe50ac1eed20913f3c1c'
  end

  depends_on 'kdelibs'
end
