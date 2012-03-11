require 'base_kde_formula'

class Uksnapshot < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/ksnapshot-4.8.1.tar.xz'
  sha1 '3e8f0842d06d0fbb98dcebeba684847552fc02a9'

  depends_on 'kdelibs'
end


