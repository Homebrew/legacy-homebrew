require 'base_kde_formula'

class Smokekde < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/smokekde-4.9.4.tar.xz'
  sha1 '6634a0cc22c26c4d30a23bfc768adacdbd75eb5d'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/smokekde-4.9.95.tar.xz'
    sha1 '0e67e797562954e2ad35e3c83782826a5fb2acf7'
  end

  depends_on 'kdelibs'
end
