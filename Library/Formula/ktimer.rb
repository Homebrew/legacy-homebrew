require 'base_kde_formula'

class Uktimer < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/ktimer-4.8.1.tar.xz'
  sha1 'c16ace45eefe9d495086a08fb1c0144baec9572f'

  depends_on 'kdelibs'
end


