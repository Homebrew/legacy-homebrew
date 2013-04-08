require 'base_kde_formula'

class Klickety < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/klickety-4.10.2.tar.xz'
  sha1 '54548dd1ebad1481ecda5a50df7e72a43a6a8cbb'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/klickety-4.10.2.tar.xz'
    sha1 '54548dd1ebad1481ecda5a50df7e72a43a6a8cbb'
  end

  depends_on 'kdelibs'
end
