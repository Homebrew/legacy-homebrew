require 'base_kde_formula'

class Pairs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/pairs-4.10.2.tar.xz'
  sha1 '24b556965b7cf11bdafb85706d8c4e3c1c3aad1e'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/pairs-4.10.2.tar.xz'
    sha1 '24b556965b7cf11bdafb85706d8c4e3c1c3aad1e'
  end

  depends_on 'kdelibs'
end
