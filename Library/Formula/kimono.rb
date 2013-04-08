require 'base_kde_formula'

class Kimono < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kimono-4.10.2.tar.xz'
  sha1 'b5ada2536a4f59b4016fc4e71d91da029ced8103'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kimono-4.10.2.tar.xz'
    sha1 'b5ada2536a4f59b4016fc4e71d91da029ced8103'
  end

  depends_on 'kdelibs'
end
