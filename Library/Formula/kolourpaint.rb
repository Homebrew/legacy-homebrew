require 'base_kde_formula'

class Kolourpaint < BaseKdeFormula
  homepage 'http://www.kolourpaint.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kolourpaint-4.10.2.tar.xz'
  sha1 '54c0999d3ce68ff4a28c879ac3743d22c76b0937'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kolourpaint-4.10.2.tar.xz'
    sha1 '54c0999d3ce68ff4a28c879ac3743d22c76b0937'
  end

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
