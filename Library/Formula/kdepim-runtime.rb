require 'base_kde_formula'

class KdepimRuntime < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdepim-runtime-4.9.4.tar.xz'
  sha1 '5d6466761e890b2ee0ce66b274553c10f2827ca0'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdepim-runtime-4.9.95.tar.xz'
    sha1 '8695d188f360b955fb430d4a99498e4e2e777fe9'
  end

  depends_on 'kdelibs'
end
