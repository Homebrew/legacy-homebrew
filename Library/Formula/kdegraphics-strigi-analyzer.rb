require 'base_kde_formula'

class KdegraphicsStrigiAnalyzer < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdegraphics-strigi-analyzer-4.10.2.tar.xz'
  sha1 '3d09bd886eb8f94a0492748e2500af539b5aa339'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdegraphics-strigi-analyzer-4.10.2.tar.xz'
    sha1 '3d09bd886eb8f94a0492748e2500af539b5aa339'
  end

  depends_on 'kdelibs'
end
