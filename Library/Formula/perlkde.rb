require 'base_kde_formula'

class Uperlkde < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/perlkde-4.8.1.tar.xz'
  sha1 '93e3b009c972a697aebf0450c4c07ff87a5c0461'

  depends_on 'kdelibs'
end


