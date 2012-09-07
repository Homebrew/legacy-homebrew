require 'base_kde_formula'

class Ulibksane < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/libksane-4.8.1.tar.xz'
  sha1 '20631624185f8bf26d7a8c2e7222731513e8a2ec'

  depends_on 'kdelibs'
end


