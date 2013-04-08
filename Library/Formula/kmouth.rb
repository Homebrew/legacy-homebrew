require 'base_kde_formula'

class Kmouth < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kmouth-4.10.2.tar.xz'
  sha1 '3ed90ae8a113264ef9b8c176c905f3d365443766'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kmouth-4.10.2.tar.xz'
    sha1 '3ed90ae8a113264ef9b8c176c905f3d365443766'
  end

  depends_on 'kdelibs'
end
