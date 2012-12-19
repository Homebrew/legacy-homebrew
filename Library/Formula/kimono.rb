require 'base_kde_formula'

class Kimono < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kimono-4.9.4.tar.xz'
  sha1 'af6c85518c61cbc8e70a1bf280be0f36c3b381ff'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kimono-4.9.95.tar.xz'
    sha1 'f7213b8158774ccc2476fe91977c8db919c0cbd0'
  end

  depends_on 'kdelibs'
end
