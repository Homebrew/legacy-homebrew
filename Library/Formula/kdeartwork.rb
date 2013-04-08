require 'base_kde_formula'

class Kdeartwork < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdeartwork-4.10.2.tar.xz'
  sha1 '000146f17a31d1257959e274f952e5a2f55f0a00'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdeartwork-4.10.2.tar.xz'
    sha1 '000146f17a31d1257959e274f952e5a2f55f0a00'
  end

  depends_on 'kdelibs'
end
