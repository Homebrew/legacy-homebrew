require 'base_kde_formula'

class Kdf < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdf-4.10.2.tar.xz'
  sha1 'e7f230d14188c45c226513e110ee664a4ad89cb9'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdf-4.10.2.tar.xz'
    sha1 'e7f230d14188c45c226513e110ee664a4ad89cb9'
  end

  depends_on 'kdelibs'
end
