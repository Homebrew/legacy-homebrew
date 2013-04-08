require 'base_kde_formula'

class Kcolorchooser < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kcolorchooser-4.10.2.tar.xz'
  sha1 '71d7e8415c4583ef72598bb4a50d8b2c7c83a8e6'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kcolorchooser-4.10.2.tar.xz'
    sha1 '71d7e8415c4583ef72598bb4a50d8b2c7c83a8e6'
  end

  depends_on 'kdelibs'
end
