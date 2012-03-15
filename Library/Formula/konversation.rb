require 'base_kde_formula'

class Konversation < BaseKdeFormula
  homepage 'http://konversation.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/konversation/1.4/src/konversation-1.4.tar.xz'
  md5 'f67271f08b9da75dc9daff9ecbf3b365'
  depends_on 'kdepimlibs'
end
