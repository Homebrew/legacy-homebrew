require 'base_kde_formula'

class Smokegen < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/smokegen-4.10.2.tar.xz'
  sha1 '2593b298e9b0f4f504612f42a928a2144313b4b4'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/smokegen-4.10.2.tar.xz'
    sha1 '2593b298e9b0f4f504612f42a928a2144313b4b4'
  end

  depends_on 'kdelibs'
end
