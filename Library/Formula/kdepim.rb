require 'base_kde_formula'

class Kdepim < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdepim-4.9.4.tar.xz'
  sha1 'f383306430705ff2af14518b9be90448bf857398'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdepim-4.9.95.tar.xz'
    sha1 '30507d56162f563aec3aff9f2dd5b68df6a2645f'
  end
  depends_on 'kdepimlibs'
end

