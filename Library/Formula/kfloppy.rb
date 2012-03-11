require 'base_kde_formula'

class Ukfloppy < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kfloppy-4.8.1.tar.xz'
  sha1 '78c5dfa1198d9c215ff2a22b82c4e3db2b7c0485'

  depends_on 'kdelibs'
end


