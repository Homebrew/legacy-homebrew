require 'base_kde_formula'

class Perlqt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/perlqt-4.10.2.tar.xz'
  sha1 '808aa907b5953ad2c2abb4015da5ddc01d1e2afb'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/perlqt-4.10.2.tar.xz'
    sha1 '808aa907b5953ad2c2abb4015da5ddc01d1e2afb'
  end

  depends_on 'kdelibs'
end
