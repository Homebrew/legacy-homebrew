require 'base_kde_formula'

class Kmousetool < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kmousetool-4.10.2.tar.xz'
  sha1 'd6778d9393b0a1cfa597565bc77771b78d98422f'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kmousetool-4.10.2.tar.xz'
    sha1 'd6778d9393b0a1cfa597565bc77771b78d98422f'
  end

  depends_on 'kdelibs'
end
