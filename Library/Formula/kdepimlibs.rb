require 'base_kde_formula'

class Kdepimlibs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdepimlibs-4.10.2.tar.xz'
  sha1 'ab163597d36b5457f9bcb0328f21c35777fffc34'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdepimlibs-4.10.2.tar.xz'
    sha1 'ab163597d36b5457f9bcb0328f21c35777fffc34'
  end

  depends_on 'kdelibs'
  depends_on 'gpgme'
  depends_on 'akonadi'
  depends_on 'libical'
end
