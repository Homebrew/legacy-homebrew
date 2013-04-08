require 'base_kde_formula'

class Kigo < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kigo-4.10.2.tar.xz'
  sha1 '229b2631b89b31bb1661a10c6de2770842c48e85'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kigo-4.10.2.tar.xz'
    sha1 '229b2631b89b31bb1661a10c6de2770842c48e85'
  end

  depends_on 'kdelibs'
end
