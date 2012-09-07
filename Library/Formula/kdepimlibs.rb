require 'base_kde_formula'

class Kdepimlibs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdepimlibs-4.8.1.tar.xz'
  sha1 'ccc653df34fd8f5f8eddac9a9e14f0fa1ea82839'

  depends_on 'gpgme'
  depends_on 'akonadi'
  depends_on 'libical'
  depends_on 'kdelibs'
end
