require 'base_kde_formula'

class Analitza < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/analitza-4.10.2.tar.xz'
  sha1 'e4acd6859140c3860eead695c2f20195b8df0a4a'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/analitza-4.10.2.tar.xz'
    sha1 'e4acd6859140c3860eead695c2f20195b8df0a4a'
  end

  depends_on 'kdelibs'
end
