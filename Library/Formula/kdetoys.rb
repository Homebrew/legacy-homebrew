require 'base_kde_formula'

class Kdetoys < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdetoys-4.10.2.tar.xz'
  sha1 '3fa4fc9b9ec04e9967b9a326d9dc26c3055b5e2b'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdetoys-4.10.2.tar.xz'
    sha1 '3fa4fc9b9ec04e9967b9a326d9dc26c3055b5e2b'
  end

  depends_on 'kdelibs'
end
