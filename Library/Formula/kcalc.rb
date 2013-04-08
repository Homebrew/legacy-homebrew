require 'base_kde_formula'

class Kcalc < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kcalc-4.10.2.tar.xz'
  sha1 '45f2a3eb557891e3c47a00dafb9ad3bd64bde4d8'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kcalc-4.10.2.tar.xz'
    sha1 '45f2a3eb557891e3c47a00dafb9ad3bd64bde4d8'
  end

  depends_on 'kdelibs'
end
