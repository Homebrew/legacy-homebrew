require 'base_kde_formula'

class KdepimRuntime < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdepim-runtime-4.10.2.tar.xz'
  sha1 '110715ca80a67b8fce7566379fe7a058fdca100d'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdepim-runtime-4.10.2.tar.xz'
    sha1 '110715ca80a67b8fce7566379fe7a058fdca100d'
  end

  depends_on 'kdelibs'
end
