require 'base_kde_formula'

class Parley < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/parley-4.10.2.tar.xz'
  sha1 '1e9e568c2a4dce6a61a51164c43b3930efe99664'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/parley-4.10.2.tar.xz'
    sha1 '1e9e568c2a4dce6a61a51164c43b3930efe99664'
  end

  depends_on 'kdelibs'
end
