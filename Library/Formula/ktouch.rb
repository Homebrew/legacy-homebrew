require 'base_kde_formula'

class Uktouch < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/ktouch-4.8.1.tar.xz'
  sha1 '42598cddc04de3d7ec64ea88068b2313333e02fd'

  depends_on 'kdelibs'
end


