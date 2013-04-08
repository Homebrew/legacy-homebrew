require 'base_kde_formula'

class Kfloppy < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kfloppy-4.10.2.tar.xz'
  sha1 'c79e9660ebea09aea2caffb8424e3621f30d3346'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kfloppy-4.10.2.tar.xz'
    sha1 'c79e9660ebea09aea2caffb8424e3621f30d3346'
  end

  depends_on 'kdelibs'
end
