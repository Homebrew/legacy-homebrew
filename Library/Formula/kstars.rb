require 'base_kde_formula'

class Kstars < BaseKdeFormula
  homepage 'http://edu.kde.org/kstars/'
  url 'http://download.kde.org/stable/4.10.2/src/kstars-4.10.2.tar.xz'
  sha1 'ce99c18862505eac3da729e666315d0b27daec1e'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kstars-4.10.2.tar.xz'
    sha1 'ce99c18862505eac3da729e666315d0b27daec1e'
  end

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
  depends_on 'eigen'
end
