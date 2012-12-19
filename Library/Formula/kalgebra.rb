require 'base_kde_formula'

class Kalgebra < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kalgebra-4.9.4.tar.xz'
  sha1 'e9b68afaad38f42d569f214123a6c8e352cbd3a3'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kalgebra-4.9.95.tar.xz'
    sha1 '5b624e96e1d6d2c2dddab70c5b13daf284f3f57f'
  end

  depends_on 'kdelibs'
end
