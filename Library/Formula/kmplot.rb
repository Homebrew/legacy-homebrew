require 'base_kde_formula'

class Kmplot < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kmplot-4.10.2.tar.xz'
  sha1 '938f0888702e3d294aba8084b4268d883fd7514e'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kmplot-4.10.2.tar.xz'
    sha1 '938f0888702e3d294aba8084b4268d883fd7514e'
  end

  depends_on 'kdelibs'
end
