require 'base_kde_formula'

class Qyoto < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/qyoto-4.10.2.tar.xz'
  sha1 'eaeb11ace135a0c9daceaa03067f056255d77dc8'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/qyoto-4.10.2.tar.xz'
    sha1 'eaeb11ace135a0c9daceaa03067f056255d77dc8'
  end

  depends_on 'kdelibs'
end
