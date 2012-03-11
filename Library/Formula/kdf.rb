require 'base_kde_formula'

class Ukdf < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdf-4.8.1.tar.xz'
  sha1 'fb28f99b23819f3618a8857affdaad1957f8bd68'

  depends_on 'kdelibs'
end


