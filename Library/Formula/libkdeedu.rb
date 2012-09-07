require 'base_kde_formula'

class Ulibkdeedu < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/libkdeedu-4.8.1.tar.xz'
  sha1 'ab9ed54dcb99f7cfe98623aa47434841f372a5a7'

  depends_on 'kdelibs'
end


