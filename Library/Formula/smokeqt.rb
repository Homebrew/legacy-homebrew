require 'base_kde_formula'

class Smokeqt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/smokeqt-4.9.4.tar.xz'
  sha1 '171b3c1cc0e7986ffb2d96a9ff844300e98746bf'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/smokeqt-4.9.95.tar.xz'
    sha1 '9a859d3bf01aecfd08164b43cbd021330936b3e2'
  end

  depends_on 'kdelibs'
end
