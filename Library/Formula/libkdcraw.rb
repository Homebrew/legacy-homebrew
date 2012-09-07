require 'base_kde_formula'

class Ulibkdcraw < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/libkdcraw-4.8.1.tar.xz'
  sha1 '80dd47457b9803240a3002ef42d96e201d9face8'

  depends_on 'kdelibs'
end


