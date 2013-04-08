require 'base_kde_formula'

class Ktouch < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/ktouch-4.10.2.tar.xz'
  sha1 '7a7c44b1bf64fdc5109be9d1b6d1481db6a1848f'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/ktouch-4.10.2.tar.xz'
    sha1 '7a7c44b1bf64fdc5109be9d1b6d1481db6a1848f'
  end

  depends_on 'kdelibs'
end
