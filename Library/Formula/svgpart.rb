require 'base_kde_formula'

class Svgpart < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/svgpart-4.9.4.tar.xz'
  sha1 'a3829bfb4d129cb56d58b72d38f9ce6a02209d93'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/svgpart-4.9.95.tar.xz'
    sha1 '139eafff3f938b3c356cf60d1bf15d08c298e09a'
  end

  depends_on 'kdelibs'
end
