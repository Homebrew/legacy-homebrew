require 'base_kde_formula'

class Step < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/step-4.9.4.tar.xz'
  sha1 'e69b672ee8530466970c9ef7726682bbb819e051'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/step-4.9.95.tar.xz'
    sha1 'fc66e64147f01ce022352f733ffb5e3c1157478d'
  end

  depends_on 'kdelibs'
end
