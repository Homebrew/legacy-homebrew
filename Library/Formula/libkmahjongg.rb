require 'base_kde_formula'

class Libkmahjongg < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/libkmahjongg-4.10.2.tar.xz'
  sha1 '58a8d3deb165cf9041c5b606a67275b3e276c428'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/libkmahjongg-4.10.2.tar.xz'
    sha1 '58a8d3deb165cf9041c5b606a67275b3e276c428'
  end

  depends_on 'kdelibs'
end
