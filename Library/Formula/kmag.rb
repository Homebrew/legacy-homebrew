require 'base_kde_formula'

class Kmag < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kmag-4.10.2.tar.xz'
  sha1 '4bcb0153663ab67eafba4cb450b62891133b4ab2'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kmag-4.10.2.tar.xz'
    sha1 '4bcb0153663ab67eafba4cb450b62891133b4ab2'
  end

  depends_on 'kdelibs'
end
