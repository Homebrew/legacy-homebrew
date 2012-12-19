require 'base_kde_formula'

class Kruler < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kruler-4.9.4.tar.xz'
  sha1 '8df30ea040707fda547bde0435ab0843beb8a59f'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kruler-4.9.95.tar.xz'
    sha1 '4cc104c7e6852989b12e76b6c725f27ca135cd3c'
  end

  depends_on 'kdelibs'
end
