require 'base_kde_formula'

class Uqyoto < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/qyoto-4.8.1.tar.xz'
  sha1 '32ad56ce6189ce691ed46b8494c4cb446dda6016'

  depends_on 'kdelibs'
end


