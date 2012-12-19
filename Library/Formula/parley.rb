require 'base_kde_formula'

class Parley < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/parley-4.9.4.tar.xz'
  sha1 '0f6eda7075d36aa9a8a97b15e5f81bf5b99da2e9'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/parley-4.9.95.tar.xz'
    sha1 '333bbc4ee35421e7ce45512b4f48e00168b06d7d'
  end

  depends_on 'kdelibs'
end
