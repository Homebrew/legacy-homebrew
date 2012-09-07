require 'base_kde_formula'

class Ukig < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kig-4.8.1.tar.xz'
  sha1 '05a5ee09be9955bb24e5fcb926eb5bb8f0b24459'

  depends_on 'kdelibs'
end


