require 'base_kde_formula'

class Marble < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/marble-4.10.2.tar.xz'
  sha1 'e4ba6aaaa5f861f715a7c4881dd78ed1deb03a36'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/marble-4.10.2.tar.xz'
    sha1 'e4ba6aaaa5f861f715a7c4881dd78ed1deb03a36'
  end

  depends_on 'kdelibs'
end
