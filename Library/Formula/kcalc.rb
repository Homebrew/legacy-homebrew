require 'base_kde_formula'

class Ukcalc < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kcalc-4.8.1.tar.xz'
  sha1 'f119707ece800a2102eb881402a5bc289b2a55ea'

  depends_on 'kdelibs'
end


