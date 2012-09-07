require 'base_kde_formula'

class Libkipi < BaseKdeFormula
  homepage 'http://kde.org'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/libkipi-4.8.1.tar.xz'
  sha1 'bc290e3354c206d7852433aac704fc96b3a55700'
  depends_on 'kdelibs'
end
