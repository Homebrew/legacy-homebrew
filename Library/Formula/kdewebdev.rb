require 'base_kde_formula'

class Kdewebdev < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdewebdev-4.10.2.tar.xz'
  sha1 '3ab68cf5fefbfe09826e659a097d21821771a5b9'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdewebdev-4.10.2.tar.xz'
    sha1 '3ab68cf5fefbfe09826e659a097d21821771a5b9'
  end

  depends_on 'kdelibs'
end
