require 'base_kde_formula'

class Svgpart < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/svgpart-4.10.2.tar.xz'
  sha1 'a361a8361fb123cb4b6498dba3b2d88293d88344'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/svgpart-4.10.2.tar.xz'
    sha1 'a361a8361fb123cb4b6498dba3b2d88293d88344'
  end

  depends_on 'kdelibs'
end
