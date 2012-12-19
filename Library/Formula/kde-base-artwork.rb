require 'base_kde_formula'

class Kde-base-artwork < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-base-artwork-4.9.4.tar.xz'
  sha1 'ab7b1746ce7fce494e5b48c8e42675ce733eb6e8'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-base-artwork-4.9.95.tar.xz'
    sha1 'e1656e5eb8856f191e23cc004e591390d8b7d77f'
  end

  depends_on 'kdelibs'
end
