require 'base_kde_formula'

class Kdepimlibs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdepimlibs-4.9.4.tar.xz'
  sha1 '78fb5ec8d8a0cbd145f44d76618705c1e3e3b0a3'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdepimlibs-4.9.95.tar.xz'
    sha1 '1a88826f75143ad2f2ab76d1c434a643ba1db5be'
  end

  depends_on 'kdelibs'
  depends_on 'gpgme'
  depends_on 'akonadi'
  depends_on 'libical'
end
