require 'base_kde_formula'

class Smokeqt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/smokeqt-4.10.2.tar.xz'
  sha1 '6a5743917aec02e6044c711c63acd229c67eff7b'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/smokeqt-4.10.2.tar.xz'
    sha1 '6a5743917aec02e6044c711c63acd229c67eff7b'
  end

  depends_on 'kdelibs'
end
