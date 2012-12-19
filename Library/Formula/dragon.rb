require 'base_kde_formula'

class Dragon < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/dragon-4.9.4.tar.xz'
  sha1 '6dd5d1721ba09f73695eee8eaca9478baf471893'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/dragon-4.9.95.tar.xz'
    sha1 '61267c2d0389e037eb070304a2a4cf3346951b0a'
  end

  depends_on 'kdelibs'
end
