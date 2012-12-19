require 'base_kde_formula'

class Kactivities < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kactivities-4.9.4.tar.xz'
  sha1 '1e3b69751d0da8416215038bc140748df23d4f37'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kactivities-4.9.95.tar.xz'
    sha1 '2f908ab040f124bd054aff29fbe838378761a696'
  end

  depends_on 'kdelibs'
end
