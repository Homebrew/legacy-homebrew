require 'base_kde_formula'

class Perlkde < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/perlkde-4.10.2.tar.xz'
  sha1 'b57da1f88e147ff8ec25527ab7ff0ccad64ca7db'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/perlkde-4.10.2.tar.xz'
    sha1 'b57da1f88e147ff8ec25527ab7ff0ccad64ca7db'
  end

  depends_on 'kdelibs'
end
