require 'base_kde_formula'

class Kalzium < BaseKdeFormula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.0/src/kalzium-4.8.0.tar.bz2'
  homepage 'http://edu.kde.org/kalzium/'
  #md5 '73a38220f4b973f45da6134d8b8dcbb7'
  depends_on 'kdelibs'
end
