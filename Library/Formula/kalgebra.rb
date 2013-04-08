require 'base_kde_formula'

class Kalgebra < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kalgebra-4.10.2.tar.xz'
  sha1 'f029006b89aa75e6584836a90832f5130fff49b5'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kalgebra-4.10.2.tar.xz'
    sha1 'f029006b89aa75e6584836a90832f5130fff49b5'
  end

  depends_on 'kdelibs'
end
