require 'base_kde_formula'

class Ukremotecontrol < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kremotecontrol-4.8.1.tar.xz'
  sha1 '684ad9b0393081a39b2c6badb2f411846e582bb2'

  depends_on 'kdelibs'
end


