require 'base_kde_formula'

class Rocs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/rocs-4.10.2.tar.xz'
  sha1 'ab7e357732fec3a7ecccce586c6de51b829267ed'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/rocs-4.10.2.tar.xz'
    sha1 'ab7e357732fec3a7ecccce586c6de51b829267ed'
  end

  depends_on 'kdelibs'
end
