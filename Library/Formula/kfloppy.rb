require 'base_kde_formula'

class Kfloppy < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kfloppy-4.9.4.tar.xz'
  sha1 'f441d4dbb8fa9b4ed9de6c4c0cc0a4af0ca06213'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kfloppy-4.9.95.tar.xz'
    sha1 'f25aada779446cddee941b48b3bcddb9bd593b3d'
  end

  depends_on 'kdelibs'
end
