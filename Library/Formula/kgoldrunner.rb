require 'base_kde_formula'

class Kgoldrunner < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kgoldrunner-4.10.2.tar.xz'
  sha1 '8c44b9992239d379d64c7979c1cd4ec56c5aa80f'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kgoldrunner-4.10.2.tar.xz'
    sha1 '8c44b9992239d379d64c7979c1cd4ec56c5aa80f'
  end

  depends_on 'kdelibs'
end
