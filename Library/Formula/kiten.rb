require 'base_kde_formula'

class Kiten < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kiten-4.9.4.tar.xz'
  sha1 'cb82fbb6c62ebd9bb9fd7a96ca62987aa7546a72'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kiten-4.9.95.tar.xz'
    sha1 '93c13fe7faca9e42b78eb0d7e5efd87311e52fdf'
  end

  depends_on 'kdelibs'
end
