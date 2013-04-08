require 'base_kde_formula'

class Kturtle < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kturtle-4.10.2.tar.xz'
  sha1 'c14cb19822fc101100938e4fcde0d50b16216cff'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kturtle-4.10.2.tar.xz'
    sha1 'c14cb19822fc101100938e4fcde0d50b16216cff'
  end

  depends_on 'kdelibs'
end
